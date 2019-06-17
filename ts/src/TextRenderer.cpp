#include "TextRenderer.h"
#include "Shader.h"
#include <glm/glm/gtc/matrix_transform.hpp>
#include <freetype/include/ft2build.h>
#include FT_FREETYPE_H  
#include <iostream>
#include "helpers.hpp"


const char* textShader_vs = "\
        #version 330 core                                                \n \
        layout(location = 0) in vec4 vertex; // <vec2 pos, vec2 tex>     \n \
        out vec2 TexCoords;                                              \n \
                                                                         \n \
        uniform mat4 projection;                                         \n \
        uniform mat4 view;                                         \n \
        uniform mat4 model;                                         \n \
                                                                         \n \
        void main() {                                                    \n \
            gl_Position = projection * view * model * vec4(vertex.xy, 0, 1);        \n \
            TexCoords = vertex.zw;                                       \n \
        }";

const char* textShader_fs = "\
        #version 330 core                                                       \n \
        in vec2 TexCoords;                                                      \n \
        out vec4 color;                                                         \n \
                                                                                \n \
        uniform sampler2D text;                                                 \n \
        uniform vec3 textColor;                                                 \n \
                                                                                \n \
        void main() {                                                           \n \
            vec4 sampled = vec4(1.0, 1.0, 1.0, texture(text, TexCoords).r);     \n \
            color = vec4(textColor, 1.0) * sampled;                             \n \
        }                                                                       \n \
        ";

TextRenderer::TextRenderer() : textShader(textShader_vs, textShader_fs) {
    textShader.use();
    // FreeType
    FT_Library ft;
    // All functions return a value different than 0 whenever an error occurred
    if (FT_Init_FreeType(&ft))
        std::cout << "ERROR::FREETYPE: Could not init FreeType Library" << std::endl;

    FT_Face face;
    if (FT_New_Face(ft, "C:\\Windows\\Fonts\\arial.ttf", 0, &face))
        std::cout << "ERROR::FREETYPE: Failed to load font" << std::endl;

    FT_Set_Pixel_Sizes(face, 0, 48);

    glPixelStorei(GL_UNPACK_ALIGNMENT, 1); // Disable byte-alignment restriction

                                           // Load first 128 characters of ASCII set
    for (GLubyte c = 0; c < 128; c++) {
        // Load character glyph 
        if (FT_Load_Char(face, c, FT_LOAD_RENDER)) {
            std::cout << "ERROR::FREETYTPE: Failed to load Glyph" << std::endl;
            continue;
        }
        // Generate texture
        GLuint texture;
        glGenTextures(1, &texture);
        glBindTexture(GL_TEXTURE_2D, texture);
        glTexImage2D(
            GL_TEXTURE_2D,
            0,
            GL_RED,
            face->glyph->bitmap.width,
            face->glyph->bitmap.rows,
            0,
            GL_RED,
            GL_UNSIGNED_BYTE,
            face->glyph->bitmap.buffer
        );
        // Set texture options
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        // Now store character for later use
        Character character = {
            texture,
            glm::ivec2(face->glyph->bitmap.width, face->glyph->bitmap.rows),
            glm::ivec2(face->glyph->bitmap_left, face->glyph->bitmap_top),
            face->glyph->advance.x
        };
        Characters.insert(std::pair<GLchar, Character>(c, character));
    }
    glBindTexture(GL_TEXTURE_2D, 0);
    // Destroy FreeType once we're finished
    FT_Done_Face(face);
    FT_Done_FreeType(ft);


    // Configure VAO/VBO for texture quads
    glGenVertexArrays(1, &TVAO);
    glGenBuffers(1, &TVBO);
    glBindVertexArray(TVAO);
    glBindBuffer(GL_ARRAY_BUFFER, TVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 6 * 4, NULL, GL_DYNAMIC_DRAW);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 4 * sizeof(GLfloat), 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);

    //Text shader init

}


TextRenderer::~TextRenderer() {
    glDeleteVertexArrays(1, &TVAO);
    glDeleteBuffers(1, &TVBO);
}

void TextRenderer::setScreensize(GLfloat width, GLfloat height) {
    textShader.use();
    //textShader.setMat4("projection", glm::ortho(0.0f, width, 0.0f, height));
}

void TextRenderer::addTextQueue(std::string text, glm::vec3 offset, GLfloat scale, glm::vec3 color) {
    textQueue.emplace_back(queueElement{ text, offset, scale, color });
}


void TextRenderer::drawQueue() {
    // Activate corresponding render state	
    textShader.use();

    glActiveTexture(GL_TEXTURE0);
    glBindVertexArray(TVAO);

    for (auto& [text, offset, scale, color] : textQueue) {
        //glm::mat4 model = glm::lookAt(offset, offset+glm::vec3(0.0f, 1.f, 0.f), glm::vec3(0.0f, 0.0f, 1.0f));
        textShader.setVec3("textColor", color);
        glm::mat4 scal = glm::scale(glm::mat4(1.0), { scale,scale,scale });


        glm::mat4 rot = glm::rotate(scal, DegToRad(-90), glm::vec3(1.0f, 0.f, 0.f));
        glm::mat4 trans = glm::translate(glm::mat4(1.0f), glm::vec3{ -offset.z,-offset.y + 1,offset.x });

        textShader.setMat4("model", trans*rot);
        float xOffset = 0.f;
        float yOffset = 0.f;
        // Iterate through all characters
        std::string::const_iterator c;
        for (c = text.begin(); c != text.end(); c++) {
            if (*c == '\n') {
                xOffset = 0;
                yOffset -= 45;
                continue;
            }


            Character ch = Characters[*c];

            GLfloat xpos = xOffset + ch.Bearing.x;
            GLfloat ypos = yOffset - (ch.Size.y - ch.Bearing.y);

            GLfloat w = ch.Size.x;
            GLfloat h = ch.Size.y;
            // Update VBO for each character
            GLfloat vertices[6][4] = {
                {xpos, ypos + h, 0.0, 0.0},
                {xpos, ypos, 0.0, 1.0},
                {xpos + w, ypos, 1.0, 1.0},

                {xpos, ypos + h, 0.0, 0.0},
                {xpos + w, ypos, 1.0, 1.0},
                {xpos + w, ypos + h, 1.0, 0.0}
            };
            // Render glyph texture over quad
            glBindTexture(GL_TEXTURE_2D, ch.TextureID);
            // Update content of VBO memory
            glBindBuffer(GL_ARRAY_BUFFER, TVBO);
            glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(vertices), vertices);
            // Be sure to use glBufferSubData and not glBufferData

            glBindBuffer(GL_ARRAY_BUFFER, 0);
            // Render quad
            glDrawArrays(GL_TRIANGLES, 0, 6);
            // Now advance cursors for next glyph (note that advance is number of 1/64 pixels)
            xOffset += (ch.Advance >> 6);
            // Bitshift by 6 to get value in pixels (2^6 = 64 (divide amount of 1/64th pixels by 64 to get amount of pixels))
        }
    }
    textQueue.clear();
    glBindVertexArray(0);
    glBindTexture(GL_TEXTURE_2D, 0);
}
