#include "datatypes.h"
#include "helpers.hpp"


float dataType::fast_sqrt(float number) {
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

dataType::Position3D::Position3D(const std::string& coordinateString) {
	if (coordinateString.length() < 3)
		return; //Fail
	std::vector<std::string> coords = helpers::split(
		coordinateString.front() == '[' ? coordinateString.substr(coordinateString.length() - 2) : coordinateString
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

dataType::Position3D::operator bool() const {
	//Is initialized. Used to check if FromString was successful
					   //May optimize this by storing whether FromString was success but fpOps are fast enough
	return m_x != 0.f || m_y != 0.f || m_z != 0.f;
}

std::tuple<float, float, float> dataType::Position3D::get() const {
	return{ m_x ,m_y ,m_z };
}

float dataType::Position3D::atanyx() const {
	return atan2(m_y, m_x);
}

float dataType::Position3D::length() const {
	return fast_sqrt(m_x*m_x + m_y*m_y + m_z*m_z);
}

float dataType::Position3D::distanceTo(const Position3D& other) const {
	return Position3D(m_x - other.m_x, m_y - other.m_y, m_z - other.m_z).length();
}
