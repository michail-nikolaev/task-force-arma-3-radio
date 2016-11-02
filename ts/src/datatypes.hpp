#pragma once
#include "public_definitions.h"
#include <cstdint>
#include <vector>

#define M_PI_FLOAT 3.14159265358979323846f
namespace dataType {
	float fast_invsqrt(float number);


	class TSClientID {
	public:
		TSClientID(anyID id) : m_id(id) {}
		TSClientID(int id) : m_id(id) {}
		TSClientID(uint64_t id) : m_id(static_cast<anyID>(id)) {} //ts3plugin_infoData
		operator anyID&() { return m_id; }
		operator bool() const { return m_id != -1; }
		bool operator== (const TSClientID& other) const { return m_id == other.m_id; }
		bool operator== (const int& other) const { return m_id == static_cast<anyID>(other); }
		bool operator< (const TSClientID& other) const { return m_id < other.m_id; }
	private:
		anyID m_id;
	};

	class TSChannelID {
	public:
		TSChannelID(uint64_t id) : m_id(id) {}
		operator uint64_t&() { return m_id; }
		operator bool() const { return m_id != -1; }
		bool operator== (const TSChannelID& other) const { return m_id == other.m_id; }
		bool operator== (const int& other) const { return m_id == static_cast<uint64_t>(other); }
		bool operator< (const TSChannelID& other) const { return m_id < other.m_id; }
	private:
		uint64_t m_id;
	};

	class TSServerID {
	public:
		TSServerID(uint64_t id) : m_id(id) {}
		operator uint64_t&() { return m_id; }
		operator bool() const { return m_id != -1; }
		bool operator== (const TSServerID& other) const { return m_id == other.m_id; }
		bool operator== (const int& other) const { return m_id == static_cast<uint64_t>(other); }
		bool operator< (const TSServerID& other) const { return m_id < other.m_id; }
	private:
		uint64_t m_id;
	};

	class AngleDegrees;
	class AngleRadians {
		friend class AngleDegrees;
	public:
		constexpr AngleRadians(float radians) : angle(radians) {}
		//Conversions
		constexpr AngleRadians(const AngleDegrees& other);
		//Operators
		constexpr operator float() const { return angle; }
		AngleRadians operator+(const AngleRadians& other) const;
		//Functions
		float cosine() const { return cosf(angle); }
		float sine() const { return sinf(angle); }
		//Converts Angle from 0 to 360 to -180 to +180
		AngleRadians to180() const;
	protected:
		float angle;
	};
	constexpr AngleRadians operator "" _rad(long double _deg) { return AngleRadians(static_cast<float>(_deg)); }
	class AngleDegrees : private AngleRadians {
		friend class AngleRadians;
	public:
		constexpr AngleDegrees(float degrees) : AngleRadians(degrees) {}
		//Conversions
		constexpr AngleDegrees(const AngleRadians& other);
		constexpr AngleRadians toRadians() const { return AngleRadians(*this); }
		//Operators
		constexpr operator float() const { return angle; }
		//Functions
		float cosine() const { return cosf(toRadians()); }
		float sine() const { return sinf(toRadians()); }
		AngleDegrees to180() const {
			AngleDegrees positive(fmod(angle, 360.f));
			if (positive.angle < 0) positive.angle += 360.f;
			return positive;
		}
	};

	constexpr AngleRadians::AngleRadians(const AngleDegrees& other) : angle(other.angle * (M_PI_FLOAT / 180)) {};



	constexpr AngleDegrees operator "" _deg(long double _deg) { return AngleDegrees(static_cast<float>(_deg)); }
	class Direction3D;
	class Position3D {
		friend class Direction3D;
	public:
		//Initializers
		explicit Position3D();
		//explicit Position3D(const Position3D &obj) = delete;
		//explicit Position3D(const TS3_VECTOR& vec) :m_x(vec.x), m_y(vec.y), m_z(vec.z) {}
		explicit Position3D(float x, float y, float z);
		explicit Position3D(const std::vector<float>& vec);
		explicit Position3D(const std::string& coordinateString);
		//Conversions
		operator TS3_VECTOR*();
		//Operators
		Position3D& operator=(const Position3D& other);
		Position3D operator-(const Position3D& other) const;
		bool operator< (const Position3D& other) const;
		bool operator== (const Position3D& other) const;
		operator bool() const;

		//Functions
		std::tuple<float, float, float> get() const;
		float length() const;
		float dotProduct(const Position3D& other) const;
		float distanceTo(const Position3D& other) const;
		Direction3D directionTo(const Position3D& other) const;
		Position3D crossProduct(const Position3D& other) const;
		Position3D normalized();
	protected:
		float m_x = 0.f;
		float m_y = 0.f;
		float m_z = 0.f;

		//When adding variables never add them before the 3D vector floats! Because operator TS3_VECTOR*
	};
	
	class RotationMatrix {
	public:
		Position3D right;
		Position3D up;
		Position3D forward;
	};
	//Unit direction Vector
	class Direction3D : protected Position3D {
		friend class Position3D;
	public:
		explicit Direction3D() : Position3D() {};
		explicit Direction3D(const std::string& coordinateString);
		explicit Direction3D(const Position3D& from, const Position3D& to);
		using Position3D::length;
		using Position3D::get;
		using Position3D::dotProduct;
		AngleRadians toAngle() const;
		AngleRadians toPolarAngle() const;
		Direction3D(float x, float y, float z) : Position3D(x, y, z) {}
		Position3D getpos() const { return Position3D(m_x,m_y,m_z); }

		//Direction3D getUpVector();
		//RotationMatrix toRotationMatrix();
		operator AngleRadians() const { return toAngle(); }
		operator AngleDegrees() const { return AngleDegrees(toAngle()); }
	};










}
