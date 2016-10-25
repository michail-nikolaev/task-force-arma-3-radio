#pragma once
#include "public_definitions.h"
#include <cstdint>
#include <vector>

namespace dataType {
	float fast_sqrt(float number);


	class TSClientID {
	public:
		explicit TSClientID(anyID id) : m_id(id) {}
	private:
		anyID m_id;
	};

	class TSChannelID {
	public:
		explicit TSChannelID(uint64_t id) : m_id(id) {}
	private:
		uint64_t m_id;
	};

	class Position3D {
	public:
		//Initializers
		explicit Position3D();
		//explicit Position3D(const TS3_VECTOR& vec) :m_x(vec.x), m_y(vec.y), m_z(vec.z) {}
		explicit Position3D(float x, float y, float z);
		explicit Position3D(const std::vector<float>& vec);
		explicit Position3D(const std::string& coordinateString);
		//Conversions
		operator TS3_VECTOR*();

		//Operators
		Position3D& operator=(const Position3D& other);
		bool operator< (const Position3D& other) const;
		bool operator== (const Position3D& other) const;
		operator bool() const;

		//Functions
		std::tuple<float, float, float> get() const;
		float atanyx() const;
		float length() const;
		float distanceTo(const Position3D& other) const;

	private:
		float m_x = 0.f;
		float m_y = 0.f;
		float m_z = 0.f;

		//When adding variables never add them before the 3D vector floats! Because operator TS3_VECTOR*
	};











}
