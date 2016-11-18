#include "datatypes.hpp"
#include "helpers.hpp"
#include <math.h>


float dataType::fast_invsqrt(float number) {
    //Quake is awesome!
    long i;
    float x2, y;
    const float threehalfs = 1.5F;

    x2 = number * 0.5F;
    y = number;
    i = *reinterpret_cast<long *>(&y);
    i = 0x5f3759df - (i >> 1);
    y = *reinterpret_cast<float *>(&i);
    y = y * (threehalfs - (x2 * y * y));
    return y;
}



dataType::Vector3D::Vector3D(float x, float y, float z) :m_x(x), m_y(y), m_z(z) {

}

dataType::Vector3D::Vector3D(const std::vector<float>& vec) {
    switch (vec.size()) {
        case 2:m_x = vec.at(0); m_y = vec.at(1);	break;
        case 3:m_x = vec.at(0); m_y = vec.at(1); m_z = vec.at(2); break;
    }
}

dataType::Vector3D::Vector3D(const boost::string_ref& coordinateString) {
    if (coordinateString.length() < 3)
        return; //Fail
    std::vector<boost::string_ref> coords; coords.reserve(3);
    helpers::split(
        coordinateString.front() == '[' ? coordinateString.substr(1, coordinateString.length() - 2) : coordinateString
        , ',', coords);
    switch (coords.size()) {
        case 2:
            m_x = helpers::parseArmaNumber(coords.at(0).data());
            m_y = helpers::parseArmaNumber(coords.at(1).data());
            break;
        case 3:
            m_x = helpers::parseArmaNumber(coords.at(0).data());
            m_y = helpers::parseArmaNumber(coords.at(1).data());
            m_z = helpers::parseArmaNumber(coords.at(2).data());
            break;
            //default Fail
    }
}
 
bool dataType::Vector3D::operator==(const Vector3D& other) const {
    return 	m_x == other.m_x && m_y == other.m_y && m_z == other.m_z;
}

Vector3D& dataType::Vector3D::operator=(const Vector3D& other) {
    m_x = other.m_x;
    m_y = other.m_y;
    m_z = other.m_z;
    return *this;
}

Vector3D Vector3D::operator-(const Vector3D& other) const {
    return Vector3D(
        m_x - other.m_x,
        m_y - other.m_y,
        m_z - other.m_z);
}

bool dataType::Vector3D::operator<(const Vector3D& other) const {
    //Is this of any use?
    return length() < other.length();
}


std::tuple<float, float, float> dataType::Vector3D::get() const {
    return{ m_x ,m_y ,m_z };
}

float dataType::Vector3D::length() const {
    return sqrt(m_x*m_x + m_y*m_y + m_z*m_z);
}

float dataType::Vector3D::dotProduct(const Vector3D& other) const {
    return m_x*other.m_x + m_y*other.m_y + m_z*other.m_z;
}

dataType::Vector3D dataType::Vector3D::normalized() {
    Vector3D other;
    float len = dataType::fast_invsqrt(length());
    if (len != 0) {
        other.m_x = m_x * len;
        other.m_y = m_y * len;
        other.m_z = m_z * len;
    }
    return other;
}

bool dataType::Vector3D::isNull() const {
    //Is initialized. Used to check if FromString was successful
    //May optimize this by storing whether FromString was success but fpOps are fast enough
    return m_x == 0.f && m_y == 0.f && m_z == 0.f;
}

dataType::Position3D::operator TS3_VECTOR*() {
    //Dirty way to pass Position3D to Teamspeak functions expecting their datatype
    return reinterpret_cast<TS3_VECTOR*>(this);
}

float dataType::Position3D::distanceTo(const Position3D& other) const {
    float distance = Position3D(m_x - other.m_x, m_y - other.m_y, m_z - other.m_z).length();
    return distance;
}

dataType::Direction3D dataType::Position3D::directionTo(const Position3D& other) const {
    return Direction3D(*this, other);
}

dataType::Position3D dataType::Position3D::crossProduct(const Position3D& other) const {
    return Position3D(
        m_y*other.m_z - m_z*other.m_y,
        m_z*other.m_x - m_x*other.m_z,
        m_x*other.m_y - m_y*other.m_x
    );
}


dataType::AngleRadians dataType::Direction3D::toAngle() const {
    return AngleRadians(atan2(m_x, m_y));
}

AngleRadians dataType::Direction3D::toPolarAngle() const {
    return AngleRadians(atan2(m_y, m_x));
}

dataType::Direction3D::Direction3D(const Position3D& from, const Position3D& to) : Vector3D((to - from).normalized()) {}

//dataType::RotationMatrix dataType::Direction3D::toRotationMatrix() {
//	Direction3D upvector = getUpVector();
//	Position3D xaxis = upvector.crossProduct(*this).normalized();
//
//	Position3D yaxis = crossProduct(xaxis).normalized();
//
//	RotationMatrix output;
//	output.right.m_x = xaxis.m_x;
//	output.right.m_y = yaxis.m_x;
//	output.right.m_z = m_x;
//
//	output.up.m_x = xaxis.m_y;
//	output.up.m_y = yaxis.m_y;
//	output.up.m_z = m_y;
//
//	output.forward.m_x = xaxis.m_z;
//	output.forward.m_y = yaxis.m_z;
//	output.forward.m_z = m_z;
//	return output;
//}

Velocity3D dataType::Velocity3D::operator*(const std::chrono::duration<float>& time) {
    return Vector3D::operator*(time.count());
}



AngleRadians AngleRadians::operator+(const AngleRadians& other) const {
    float newAngle = angle + other.angle;
    while (newAngle > M_PI_FLOAT * 2) //convert 370°->10°
        newAngle -= M_PI_FLOAT * 2;
    return AngleRadians(newAngle);
}

AngleRadians AngleRadians::to180() const {
    AngleRadians _180(angle);
    while (_180.angle > M_PI_FLOAT) {
        _180.angle = _180.angle - M_PI_FLOAT;
    }
    return _180;
}

constexpr AngleDegrees::AngleDegrees(const AngleRadians& other) :angle(other.angle * (180 / M_PI_FLOAT)) {

}
