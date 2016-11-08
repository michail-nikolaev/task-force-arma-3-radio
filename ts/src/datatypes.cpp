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

bool dataType::Position3D::operator==(const Position3D& other) const {
	return 	m_x == other.m_x && m_y == other.m_y && m_z == other.m_z;
}

Position3D& dataType::Position3D::operator=(const Position3D& other) {
	m_x = other.m_x;
	m_y = other.m_y;
	m_z = other.m_z;
	return *this;
}

Position3D Position3D::operator-(const Position3D& other) const {
	return Position3D(
		m_x - other.m_x,
		m_y - other.m_y,
		m_z - other.m_z);
}

dataType::Position3D::Position3D(const std::string& coordinateString) {
	if (coordinateString.length() < 3)
		return; //Fail
	std::vector<std::string> coords = helpers::split(
		coordinateString.front() == '[' ? coordinateString.substr(1,coordinateString.length() - 2) : coordinateString
		, ',');
	switch (coords.size()) {
		case 2:
			m_x = helpers::parseArmaNumber(coords.at(0));
			m_y = helpers::parseArmaNumber(coords.at(1));
			break;
		case 3:
			m_x = helpers::parseArmaNumber(coords.at(0));
			m_y = helpers::parseArmaNumber(coords.at(1));
			m_z = helpers::parseArmaNumber(coords.at(2));
			break;
			//default Fail
	}
}

dataType::Position3D::Position3D(const std::vector<float>& vec) {
	switch (vec.size()) {
		case 2:m_x = vec.at(0); m_y = vec.at(1);	break;
		case 3:m_x = vec.at(0); m_y = vec.at(1); m_z = vec.at(2); break;
	}
}

dataType::Position3D::Position3D(float x, float y, float z) :m_x(x), m_y(y), m_z(z) {

}

dataType::Position3D::Position3D() {

}

dataType::Position3D::operator TS3_VECTOR*() {
	//Dirty way to pass Position3D to Teamspeak functions expecting their datatype
	return reinterpret_cast<TS3_VECTOR*>(this);
}

bool dataType::Position3D::operator<(const Position3D& other) const {
	//Is this of any use?
	return length() < other.length();
}

bool dataType::Position3D::isNull() const {
	//Is initialized. Used to check if FromString was successful
					   //May optimize this by storing whether FromString was success but fpOps are fast enough
	return m_x == 0.f && m_y == 0.f && m_z == 0.f;
}

std::tuple<float, float, float> dataType::Position3D::get() const {
	return{ m_x ,m_y ,m_z };
}

float dataType::Position3D::length() const {
	return sqrt(m_x*m_x + m_y*m_y + m_z*m_z);
}

float dataType::Position3D::dotProduct(const Position3D& other) const {
	return m_x*other.m_x + m_y*other.m_y + m_z*other.m_z;
}

float dataType::Position3D::distanceTo(const Position3D& other) const {
	float distance = Position3D(m_x - other.m_x, m_y - other.m_y, m_z - other.m_z).length();
	return distance;
}

dataType::Direction3D dataType::Position3D::directionTo(const Position3D& other) const {
	return Direction3D(*this,other);
}

dataType::Position3D dataType::Position3D::crossProduct(const Position3D& other) const {
	return Position3D(
		m_y*other.m_z - m_z*other.m_y,
		m_z*other.m_x - m_x*other.m_z,
		m_x*other.m_y - m_y*other.m_x
	);
}

dataType::Position3D dataType::Position3D::normalized() {
	Position3D other;
	float len = length();
	if (len != 0) {
		other.m_x = m_x / len;
		other.m_y = m_y / len;
		other.m_z = m_z / len;
	}
	return other;
}

dataType::AngleRadians dataType::Direction3D::toAngle() const {
	return AngleRadians(atan2(m_x, m_y));
}

AngleRadians dataType::Direction3D::toPolarAngle() const {
	return AngleRadians(atan2(m_y, m_x));
}

dataType::Direction3D::Direction3D(const Position3D& from, const Position3D& to) {
	Position3D diff = to - from;
	float length = diff.length();
	if (length != 0) {
		m_x = diff.m_x / length;
		m_y = diff.m_y / length;
		m_z = diff.m_z / length;
	}
}

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

dataType::Direction3D::Direction3D(const std::string& coordinateString) {
	if (coordinateString.length() < 3)
		return; //Fail
	std::vector<std::string> coords = helpers::split(
		coordinateString.front() == '[' ? coordinateString.substr(1,coordinateString.length() - 2) : coordinateString
		, ',');
	switch (coords.size()) {
		case 2:
			m_x = helpers::parseArmaNumber(coords.at(0));
			m_y = helpers::parseArmaNumber(coords.at(1));
			break;
		case 3:
			m_x = helpers::parseArmaNumber(coords.at(0));
			m_y = helpers::parseArmaNumber(coords.at(1));
			m_z = helpers::parseArmaNumber(coords.at(2));
			break;
			//default Fail
	}
}

AngleRadians AngleRadians::operator+(const AngleRadians& other) const {
	float newAngle = angle + other.angle;
	while (newAngle > M_PI_FLOAT*2) //normalize 370°->10°
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

constexpr AngleDegrees::AngleDegrees(const AngleRadians& other) :AngleRadians(other.angle * (180 / M_PI_FLOAT)) {

}
