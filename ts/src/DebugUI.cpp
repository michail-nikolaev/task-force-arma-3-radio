#include "DebugUI.h"
#pragma comment(lib,"opengl32.lib")
#pragma comment(lib,"freetype.lib")

#include <freetype/include/ft2build.h>
#include FT_FREETYPE_H  


#define _GLFW_WIN32
#include <glad/include/glad/glad.h>
#include <glfw/include/GLFW/glfw3.h>
#include <glm/glm/glm.hpp>
#include <glm/glm/gtc/matrix_transform.hpp>
#include <glm/glm/gtc/type_ptr.hpp>
#include <iostream>



#include <string>
#include <iostream>
#include "task_force_radio.hpp"
#include "Teamspeak.hpp"
#include <glm/glm/simd/platform.h>

#include "Shader.h"
#include <vector>
#include "TextRenderer.h"

// Defines several possible options for camera movement. Used as abstraction to stay away from window-system specific input methods
enum Camera_Movement {
    FORWARD,
    BACKWARD,
    LEFT,
    RIGHT       ,
    up,
    down
};

// Default camera values
const float YAW = 90.0f;
const float PITCH = -90.0f;
const float SPEED = 10.f;
const float SENSITIVITY = 0.1f;
const float ZOOM = 45.0f;


// An abstract camera class that processes input and calculates the corresponding Euler Angles, Vectors and Matrices for use in OpenGL
class Camera {
public:
    // Camera Attributes
    glm::vec3 Position;
    glm::vec3 Front;
    glm::vec3 Up;
    glm::vec3 Right;
    glm::vec3 WorldUp;
    // Euler Angles
    float Yaw;
    float Pitch;
    // Camera options
    float MovementSpeed;
    float MouseSensitivity;
    float Zoom;

    // Constructor with vectors
    Camera(glm::vec3 position = glm::vec3(0.0f, 0.0f, 0.0f), glm::vec3 up = glm::vec3(0.0f, 1.0f, 0.0f), float yaw = YAW, float pitch = PITCH) : Front(glm::vec3(0.0f, 0.0f, -1.0f)), MovementSpeed(SPEED), MouseSensitivity(SENSITIVITY), Zoom(ZOOM) {
        Position = position;
        WorldUp = up;
        Yaw = yaw;
        Pitch = pitch;
        updateCameraVectors();
    }
    // Constructor with scalar values
    Camera(float posX, float posY, float posZ, float upX, float upY, float upZ, float yaw, float pitch) : Front(glm::vec3(0.0f, 0.0f, -1.0f)), MovementSpeed(SPEED), MouseSensitivity(SENSITIVITY), Zoom(ZOOM) {
        Position = glm::vec3(posX, posY, posZ);
        WorldUp = glm::vec3(upX, upY, upZ);
        Yaw = yaw;
        Pitch = pitch;
        updateCameraVectors();
    }

    // Returns the view matrix calculated using Euler Angles and the LookAt Matrix
    glm::mat4 GetViewMatrix() {
        return glm::lookAt(Position, Position + Front, Up);
    }

    // Processes input received from any keyboard-like input system. Accepts input parameter in the form of camera defined ENUM (to abstract it from windowing systems)
    void ProcessKeyboard(Camera_Movement direction, float deltaTime) {
        float velocity = MovementSpeed * deltaTime;
        if (direction == FORWARD)
            Position += Front * velocity;
        if (direction == BACKWARD)
            Position -= Front * velocity;
        if (direction == LEFT)
            Position -= Right * velocity;
        if (direction == RIGHT)
            Position += Right * velocity;
        if (direction == up)
            Position += Up * velocity;
        if (direction == down)
            Position -= Up * velocity;
    }

    // Processes input received from a mouse input system. Expects the offset value in both the x and y direction.
    void ProcessMouseMovement(float xoffset, float yoffset, GLboolean constrainPitch = true) {
        xoffset *= MouseSensitivity;
        yoffset *= MouseSensitivity;

        Yaw += xoffset;
        Pitch += yoffset;

        // Make sure that when pitch is out of bounds, screen doesn't get flipped
        if (constrainPitch) {
            if (Pitch > 89.0f)
                Pitch = 89.0f;
            if (Pitch < -89.0f)
                Pitch = -89.0f;
        }

        // Update Front, Right and Up Vectors using the updated Euler angles
        updateCameraVectors();
    }

    // Processes input received from a mouse scroll-wheel event. Only requires input on the vertical wheel-axis
    void ProcessMouseScroll(float yoffset) {
        if (Zoom >= 1.0f && Zoom <= 45.0f)
            Zoom -= yoffset;
        if (Zoom <= 1.0f)
            Zoom = 1.0f;
        if (Zoom >= 45.0f)
            Zoom = 45.0f;
    }

private:
    // Calculates the front vector from the Camera's (updated) Euler Angles
    void updateCameraVectors() {
        // Calculate the new Front vector
        glm::vec3 front;
        front.x = cos(glm::radians(Yaw)) * cos(glm::radians(Pitch));
        front.y = sin(glm::radians(Pitch));
        front.z = sin(glm::radians(Yaw)) * cos(glm::radians(Pitch));
        Front = glm::normalize(front);
        // Also re-calculate the Right and Up vector
        Right = glm::normalize(glm::cross(Front, WorldUp));  // Normalize the vectors, because their length gets closer to 0 the more you look up or down which results in slower movement.
        Up = glm::normalize(glm::cross(Right, Front));
    }
};



void framebuffer_size_callback(GLFWwindow* window, int width, int height);
void mouse_callback(GLFWwindow* window, double xpos, double ypos);
void scroll_callback(GLFWwindow* window, double xoffset, double yoffset);
void processInput(GLFWwindow *window);

// settings
const unsigned int SCR_WIDTH = 800;
const unsigned int SCR_HEIGHT = 600;

// camera
Camera camera(glm::vec3(0.0f, 30.0f, 0.0f));
float lastX = SCR_WIDTH / 2.0f;
float lastY = SCR_HEIGHT / 2.0f;
bool firstMouse = true;

// timing
float deltaTime = 0.0f;	// time between current frame and last frame
float lastFrame = 0.0f;

std::shared_ptr<clientData> centerTarget;

float debugDisplayThing = 0.f;
float debugDisplayThing2 = 0.f;


void DebugUI::threadRun() {
    // glfw: initialize and configure
    // ------------------------------
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwWindowHint(GLFW_RESIZABLE, GL_TRUE);

    GLFWwindow* window = glfwCreateWindow(SCR_WIDTH, SCR_HEIGHT, "TFAR Debug UI", nullptr, nullptr); // Windowed
    if (window == nullptr) {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return;
    }
    glfwMakeContextCurrent(window);
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
    glfwSetCursorPosCallback(window, mouse_callback);
    glfwSetScrollCallback(window, scroll_callback);

    // tell GLFW to capture our mouse
    glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_NORMAL);

    // glad: load all OpenGL function pointers
    // ---------------------------------------
    if (!gladLoadGLLoader((GLADloadproc) glfwGetProcAddress)) {
        std::cout << "Failed to initialize GLAD" << std::endl;
        return;
    }
    textRenderer = std::make_unique<TextRenderer>();
    // Define the viewport dimensions
    glViewport(0, 0, SCR_WIDTH, SCR_HEIGHT);

    // Set OpenGL options
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);



    // build and compile our shader zprogram
    // ------------------------------------

    Shader ourShader("\
        #version 330 core                                                   \n \
        layout(location = 0) in vec3 aPos;                                  \n \
        /*layout(location = 1) in vec2 aTexCoord;*/                             \n \
                                                                            \n \
        out vec3 TexCoord;                                                  \n \
                                                                            \n \
        uniform mat4 model;                                                 \n \
        uniform mat4 view;                                                  \n \
        uniform mat4 projection;                                            \n \
                                                                            \n \
        void main() {                                                       \n \
            gl_Position = projection * view * model * vec4(aPos, 1.0f);                \n \
            vec4 v = model * vec4(aPos, 1.0f);                \n \
             /*gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);*/    \n \
            TexCoord = vec3(v.x, v.y, v.z);                      \n \
        }",  "\
        #version 330 core                                                                    \n \
        out vec4 FragColor;                                                                  \n \
                                                                                             \n \
        in vec3 TexCoord;                                                                    \n \
                                                                                             \n \
        /* texture samplers*/                                                                \n   \
        uniform sampler2D texture1;                                                          \n \
        uniform sampler2D texture2;                                                          \n \
                                                                                             \n \
        void main() {                                                                        \n \
            /* linearly interpolate between both textures (80% container, 20% awesomeface)*/ \n   \
            FragColor =  vec4(TexCoord.x, TexCoord.y, TexCoord.z, 0.2f);                                          \n \
            //FragColor =  texture(texture1, TexCoord.xy);                                          \n \
        }                                                                                    \n \
                                                                                             \n \
                                                                                             \n \
        ");   //mix(texture(texture1, TexCoord), texture(texture2, TexCoord), 0.2);

    //Init verticies
    glm::vec3 vertList[] = {
        { 1.0000, -0.0000, -0.0000 },
        { 0.0000, 0.25, 0.25 },
        { -0.0000, -0.25, 0.25 },
        { -0.0000, -0.25, -0.25 },
        { 0.0000, 0.25, -0.25 }
    };

    // set up vertex data (and buffer(s)) and configure vertex attributes
    // ------------------------------------------------------------------
    glm::vec3 vertices[] = {
        vertList[1 - 1], vertList[2 - 1], vertList[3 - 1],
        vertList[1 - 1], vertList[3 - 1], vertList[4 - 1],
        vertList[1 - 1], vertList[4 - 1], vertList[5 - 1],
        vertList[1 - 1], vertList[5 - 1], vertList[2 - 1],
        vertList[5 - 1], vertList[4 - 1], vertList[3 - 1],
        vertList[3 - 1], vertList[2 - 1], vertList[5 - 1]
    };
    // world space positions of our cubes
    glm::vec3 cubePositions[] = {
        glm::vec3(1.0f,  1.0f,  1.0f),
        glm::vec3(2.0f,  5.0f, -15.0f),
        glm::vec3(-1.5f, -2.2f, -2.5f),
        glm::vec3(-3.8f, -2.0f, -12.3f),
        glm::vec3(2.4f, -0.4f, -3.5f),
        glm::vec3(-1.7f,  3.0f, -7.5f),
        glm::vec3(1.3f, -2.0f, -2.5f),
        glm::vec3(1.5f,  2.0f, -2.5f),
        glm::vec3(1.5f,  0.2f, -1.5f),
        glm::vec3(-1.3f,  1.0f, -1.5f)
    };
    unsigned int VBO, VAO;
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);

    glBindVertexArray(VAO);

    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    // position attribute
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*) 0);
    glEnableVertexAttribArray(0);
    // texture coord attribute
    //glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*) (3 * sizeof(float)));
    //glEnableVertexAttribArray(1);

    // tell opengl for each sampler to which texture unit it belongs to (only has to be done once)
    // -------------------------------------------------------------------------------------------
    ourShader.use();

    //glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    //init verticies



    // render loop
    // -----------
    while (!glfwWindowShouldClose(window) && shouldRun) {
        // per-frame time logic
        // --------------------
        float currentFrame = glfwGetTime();
        deltaTime = currentFrame - lastFrame;
        lastFrame = currentFrame;

        // input
        // -----
        processInput(window);

        // render
        // ------
        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        //// bind textures on corresponding texture units
        //glActiveTexture(GL_TEXTURE0);
        //glBindTexture(GL_TEXTURE_2D, 148);
        //glActiveTexture(GL_TEXTURE1);
        //glBindTexture(GL_TEXTURE_2D, 148);

        // activate shader

        glm::mat4 projection = glm::perspective(glm::radians(camera.Zoom), (float) SCR_WIDTH / (float) SCR_HEIGHT, 0.1f, 10000.0f);
        glm::mat4 view = camera.GetViewMatrix();


        textRenderer->textShader.use();
        textRenderer->textShader.setMat4("projection", projection);
        textRenderer->textShader.setMat4("view", view);


        ourShader.use();

        // pass projection matrix to shader (note that in this case it could change every frame)

        //glm::mat4 projection = glm::ortho(0.0f, 800.0f, 0.0f, 600.0f);
        ourShader.setMat4("projection", projection);
        // camera/view transformation
        ourShader.setMat4("view", view);

        glBindVertexArray(VAO);

        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, 148);
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, 148);


      

#if 1
        const auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(Teamspeak::getCurrentServerConnection());
        if (clientDataDir) {
            if (!centerTarget) centerTarget = clientDataDir->myClientData;
            auto localPos = clientDataDir->myClientData->getClientPosition();

            textRenderer->addTextQueue("currentTarget:" + centerTarget->getNickname() + " Arrow Right/Left to change.", glm::vec3{-5,0,5}, .01f, glm::vec3(0.5, 0.8f, 0.2f));

            auto myPos = centerTarget->getClientPosition();
            //camera.Position = { myPos[0], camera.Position.y, myPos[1] };
            glm::mat4 view = camera.GetViewMatrix();
            //view = glm::translate(view, { myPos[0],myPos[2], myPos[1] });
            ourShader.setMat4("view", view);
            //std::cout << camera.Front.x << camera.Front.y << camera.Front.z << "\n";


            //glUseProgram(shaderProgram);
            // render boxes
            std::vector<glm::vec3> lineConnects;
            clientDataDir->forEachClient([&](const std::shared_ptr<clientData>& cli) {
                // calculate the model matrix for each object and pass it to shader before drawing
                auto pos = myPos- cli->getClientPosition();
                auto dir = cli->getViewDirection().normalized();

                //std::string msg = cli->getNickname() + " x " + pos.toString() + " x " + dir.toString();

                //Teamspeak::printMessageToCurrentTab(msg.c_str());
                glm::vec3 position{ pos[1], pos[2], pos[0] };

                auto yaw = std::atan2(dir[0], dir[1]);
                auto pitch = std::asin(dir.normalized()[2]);

                glm::mat4 model = glm::lookAt(position, position + glm::vec3{1,0,0}, glm::vec3{ 0,1,0 });
                model = glm::rotate(model, -yaw, { 0,1,0 });
                model = glm::rotate(model, pitch, { 0,0,1 });

                ourShader.setMat4("model", model);

                glDrawArrays(GL_TRIANGLES, 0, 18);

                lineConnects.emplace_back(glm::vec3{ 0,0,0 });
                lineConnects.emplace_back(glm::vec3{ -position.x,-position.y ,-position.z });


                std::stringstream text;
                text << cli->getNickname() << "(" << localPos.distanceTo(cli->getClientPosition()) <<"m) freq: " << cli->getCurrentTransmittingFrequency() << "\n subtype: " << cli->getCurrentTransmittingSubtype() << '\n';
                
                if (cli->objectInterception > 0)
                    text << "object interception: " << cli->objectInterception << '\n';
                auto vehDesc = cli->getVehicleDescriptor();
                text << "vehicle: " << vehDesc.vehicleName << " iso: " << vehDesc.vehicleIsolation << " intercom:" << vehDesc.intercomSlot << '\n';

                text << "d1:" << debugDisplayThing << "\nd2:" << debugDisplayThing2 << "\n";


                textRenderer->addTextQueue(text.str(), position, .005f, cli->clientTalkingNow ? glm::vec3(1.f, 0.f, 0.2f) : glm::vec3(0.5, 0.8f, 0.2f));

            });

            glm::mat4 model = glm::lookAt(glm::vec3(), glm::vec3(1.0f, 0.f, 0.f), glm::vec3(0.0f, 1.0f, 0.0f));
            ourShader.setMat4("model", model);
            glLineWidth(5);
            glBufferData(GL_ARRAY_BUFFER, lineConnects.size() * sizeof(glm::vec3), lineConnects.data(), GL_STATIC_DRAW);
            glDrawArrays(GL_LINES, 0, lineConnects.size());

        } else {
            glClearColor(0.7f, 0.3f, 0.3f, 1.0f);
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        }
#else

        std::vector<glm::vec3> lineConnects;
        for (auto& it : cubePositions) {

            // calculate the model matrix for each object and pass it to shader before drawing
            glm::mat4 model = glm::lookAt(it, it + glm::vec3(1.0f, 0.f, 0.f), glm::vec3(0.0f, 1.0f, 0.0f));
            //model = glm::scale(model, { 1,0.7f,0.2f });
            //model = glm::translate(model, it);
            float angle = 20.0f;
            //model = glm::rotate(model, glm::radians(angle), glm::vec3(1.0f, 0.3f, 0.5f));
            ourShader.setMat4("model", model);
            //ourShader.setVec3("model", it);
        
            glDrawArrays(GL_TRIANGLES, 0, 18);

            lineConnects.emplace_back(glm::vec3{ 0,0,0 });
            lineConnects.emplace_back(glm::vec3{ -it.x,-it.y ,-it.z });
            

            //auto proj = glm::project(it, model,projection, glm::vec4{ 0,0,SCR_WIDTH,SCR_HEIGHT });
            textRenderer->addTextQueue("proj\n" + std::to_string(it.x), it, 0.01f, glm::vec3(0.5, 0.8f, 0.2f));
        }
        glm::mat4 model = glm::lookAt(glm::vec3(),  glm::vec3(1.0f, 0.f, 0.f), glm::vec3(0.0f, 1.0f, 0.0f));
        ourShader.setMat4("model", model);
        glLineWidth(5);
        glBufferData(GL_ARRAY_BUFFER, lineConnects.size()*sizeof(glm::vec3), lineConnects.data(), GL_STATIC_DRAW);
        glDrawArrays(GL_LINES, 0, lineConnects.size());
#endif

        textRenderer->drawQueue();

        // glfw: swap buffers and poll IO events (keys pressed/released, mouse moved etc.)
        // -------------------------------------------------------------------------------
        glfwSwapBuffers(window);
        glfwPollEvents();
    }

    // optional: de-allocate all resources once they've outlived their purpose:
    // ------------------------------------------------------------------------
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);

    // glfw: terminate, clearing all previously allocated GLFW resources.
    // ------------------------------------------------------------------
    glfwTerminate();
    return;
}

// process all input: query GLFW whether relevant keys are pressed/released this frame and react accordingly
// ---------------------------------------------------------------------------------------------------------
void processInput(GLFWwindow *window) {
    //if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
    //    glfwSetWindowShouldClose(window, true);

    float mult = glfwGetKey(window, GLFW_KEY_LEFT_SHIFT) == GLFW_PRESS ? 10.f : 1.f;

    if (glfwGetKey(window, GLFW_KEY_W) == GLFW_PRESS)
        camera.ProcessKeyboard(up, deltaTime * mult);
    if (glfwGetKey(window, GLFW_KEY_S) == GLFW_PRESS)
        camera.ProcessKeyboard(down, deltaTime* mult);
    if (glfwGetKey(window, GLFW_KEY_A) == GLFW_PRESS)
        camera.ProcessKeyboard(LEFT, deltaTime* mult);
    if (glfwGetKey(window, GLFW_KEY_D) == GLFW_PRESS)
        camera.ProcessKeyboard(RIGHT, deltaTime* mult);
    if (glfwGetKey(window, GLFW_KEY_Q) == GLFW_PRESS)
        camera.ProcessKeyboard(BACKWARD, deltaTime* mult);
    if (glfwGetKey(window, GLFW_KEY_E) == GLFW_PRESS)
        camera.ProcessKeyboard(FORWARD, deltaTime* mult);

   

    const auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(Teamspeak::getCurrentServerConnection());
    if (!centerTarget) centerTarget = clientDataDir->myClientData;

    std::vector<std::shared_ptr<clientData>> clientList;
    clientDataDir->forEachClient([&](const std::shared_ptr<clientData>&d ) {
       clientList.push_back(d);
    });
   
    auto found = std::find(clientList.begin(), clientList.end(), centerTarget);
    if (found == clientList.end()) found = clientList.begin();
    static int press = 0;

    if (glfwGetKey(window, GLFW_KEY_RIGHT) == GLFW_PRESS && press!=1) {
        ++found;
        if (found == clientList.end()) found = clientList.begin();
        centerTarget = *found;
        press = 1;
    }

    if (glfwGetKey(window, GLFW_KEY_LEFT) == GLFW_PRESS && press != 2) {
        if (found == clientList.begin()) found = clientList.end();
        --found;
        centerTarget = *found;
        press = 2;
    }
    if (glfwGetKey(window, GLFW_KEY_LEFT) == GLFW_RELEASE && press == 2) press = 0;
    if (glfwGetKey(window, GLFW_KEY_RIGHT) == GLFW_RELEASE && press == 1) press = 0;


}

// glfw: whenever the window size changed (by OS or user resize) this callback function executes
// ---------------------------------------------------------------------------------------------
void framebuffer_size_callback(GLFWwindow* window, int width, int height) {
    // make sure the viewport matches the new window dimensions; note that width and 
    // height will be significantly larger than specified on retina displays.
    glViewport(0, 0, width, height);
}


// glfw: whenever the mouse moves, this callback is called
// -------------------------------------------------------
void mouse_callback(GLFWwindow* window, double xpos, double ypos) {
    if (firstMouse) {
        lastX = xpos;
        lastY = ypos;
        firstMouse = false;
    }

    float xoffset = xpos - lastX;
    float yoffset = lastY - ypos; // reversed since y-coordinates go from bottom to top

    lastX = xpos;
    lastY = ypos;

    //camera.ProcessMouseMovement(xoffset, yoffset);
}

// glfw: whenever the mouse scroll wheel scrolls, this callback is called
// ----------------------------------------------------------------------
void scroll_callback(GLFWwindow* window, double xoffset, double yoffset) {
    camera.ProcessMouseScroll(yoffset);
}


DebugUI::DebugUI() {

}


DebugUI::~DebugUI() {
    if (shouldRun) {
        stop();
    }
}

void DebugUI::run() {
    uiThread = new std::thread([this]() {


        threadRun();

        //HDC hDC;				/* device context */
        //HGLRC hRC;				/* opengl context */
        //HWND  hWnd;				/* window */
        //MSG   msg;				/* message */
        //
        //hWnd = CreateOpenGLWindow("minimal", 0, 0, 256, 256, PFD_TYPE_RGBA, 0);
        //if (hWnd == NULL)
        //    return;
        //
        //hDC = GetDC(hWnd);
        //hRC = wglCreateContext(hDC);
        //wglMakeCurrent(hDC, hRC);
        //
        //ShowWindow(hWnd, SW_SHOW);
        //
        //while (GetMessage(&msg, hWnd, 0, 0) && shouldRun) {
        //    TranslateMessage(&msg);
        //    DispatchMessage(&msg);
        //}
        //
        //wglMakeCurrent(NULL, NULL);
        //ReleaseDC(hWnd, hDC);
        //wglDeleteContext(hRC);
        //DestroyWindow(hWnd);
    });

}

void DebugUI::stop() {
    shouldRun = false;
    if (uiThread) {
        uiThread->join();
        delete uiThread;
    }
}
