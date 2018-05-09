#pragma once
#include <glad/include/glad/glad.h>
#include <map>
#include <glm/glm/glm.hpp>
#include "Shader.h"
#include <vector>

class TextRenderer {
public:
	TextRenderer();
	~TextRenderer();
    void setScreensize(GLfloat x, GLfloat y);


    struct Character {
        GLuint     TextureID;  // ID handle of the glyph texture
        glm::ivec2 Size;       // Size of glyph
        glm::ivec2 Bearing;    // Offset from baseline to left/top of glyph
        GLuint     Advance;    // Offset to advance to next glyph
    };

    GLuint TVAO, TVBO;
    void addTextQueue(std::string text, glm::vec2 offset, GLfloat scale, glm::vec3 color);
    void drawQueue();

    struct queueElement {
        std::string text;
        glm::vec2 offset;
        GLfloat scale;
        glm::vec3 color;
    };

    std::vector<queueElement> textQueue;
    std::map<GLchar, Character> Characters;
    Shader textShader;
};

