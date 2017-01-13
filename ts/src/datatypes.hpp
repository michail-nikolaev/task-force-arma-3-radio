#pragma once
#include "public_definitions.h"
#include <cstdint>
#include <vector>
#include "string_ref.hpp"
#include <chrono>

#define M_PI_FLOAT 3.14159265358979323846f
namespace dataType {
    float fast_invsqrt(float number);


    template <typename Type>
    class TeamspeakID {
    public:
        constexpr TeamspeakID() : m_id(-1) {}
        constexpr TeamspeakID(Type id) : m_id(id) {}
        constexpr TeamspeakID(int id) : m_id(id) {}
        constexpr Type baseType() const { return m_id; }//Making this operator Type() will break operator bool in if statements... C++ Magic
        constexpr bool isValid() const noexcept { return m_id != static_cast<Type>(-1) && m_id > 0; }
        constexpr explicit operator bool() const noexcept { return isValid(); }
        constexpr bool operator!() const noexcept { return !isValid(); }
        constexpr bool operator== (const TeamspeakID& other) const noexcept { return m_id == other.m_id; }
        constexpr bool operator== (const int& other) const noexcept { return m_id == static_cast<Type>(other); }
        constexpr bool operator== (const Type& other) const noexcept { return m_id == other; }
        constexpr bool operator!= (const TeamspeakID& other) const noexcept { return m_id != other.m_id; }
        constexpr bool operator< (const TeamspeakID& other) const noexcept { return m_id < other.m_id; }
    private:
        Type m_id;
    };

    using TSClientID = TeamspeakID<anyID>;
    using TSChannelID = TeamspeakID<uint64_t>;
    using TSServerID = TeamspeakID<uint64_t>;

    // static_assert(TSClientID(5));
    static_assert(!TSClientID(-1).isValid(), "Empty TSClientID detection failed");

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
    class AngleDegrees {
        friend class AngleRadians;
    public:
        constexpr AngleDegrees(float degrees) : angle(degrees) {}
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
    protected:
        float angle;
    };

    constexpr AngleRadians::AngleRadians(const AngleDegrees& other) : angle(other.angle * (M_PI_FLOAT / 180)) {};



    constexpr AngleDegrees operator "" _deg(long double _deg) { return AngleDegrees(static_cast<float>(_deg)); }

    class Vector3D {
    public:
        Vector3D() {};
        Vector3D(float x, float y, float z);
        Vector3D(const std::vector<float>& vec);
        Vector3D(const boost::string_ref& coordinateString);
        Vector3D(Vector3D&& vec) : m_x(std::move(vec.m_x)), m_y(std::move(vec.m_y)), m_z(std::move(vec.m_z)) {};
        Vector3D(const Vector3D& vec) : m_x(vec.m_x), m_y(vec.m_y), m_z(vec.m_z) {};

        std::tuple<float, float, float> get() const; //#TODO instead of using get.. how about operator[] ?
        float length() const;
        float dotProduct(const Vector3D& other) const;
        Vector3D normalized();
        bool isNull() const;
        Vector3D operator*(float multiplier) {
            return{ m_x *multiplier,m_y *multiplier ,m_z *multiplier };
        }
        Vector3D& operator=(const Vector3D& other);
        Vector3D operator-(const Vector3D& other) const;
        Vector3D operator+(const Vector3D& other) const;
        bool operator< (const Vector3D& other) const;
        bool operator== (const Vector3D& other) const;
        Vector3D operator/(float div) const;

    protected:
        float m_x = 0.f;
        float m_y = 0.f;
        float m_z = 0.f;
    };


    class Direction3D;
    class Position3D : public Vector3D {
    public:
        using Vector3D::Vector3D;
        //Initializers
        Position3D() {};
        Position3D(const Vector3D& other) : Vector3D(other) {}
        //explicit Position3D(const Position3D &obj) = delete;
        //explicit Position3D(const TS3_VECTOR& vec) :m_x(vec.x), m_y(vec.y), m_z(vec.z) {}
        //Conversions
        operator TS3_VECTOR*();
        //Operators

        //Functions
        float getHeight() const;
        float distanceTo(const Position3D& other) const; 
        float distanceUnderwater(const Position3D& other) const;
        Direction3D directionTo(const Position3D& other) const;
        Position3D crossProduct(const Position3D& other) const;
        Position3D normalized() {};
    };

    //Unit direction Vector
    class Direction3D : public Vector3D {
        friend class Position3D;
    public:
        template <typename ...Args>
        Direction3D(Args&&... args) : Vector3D(std::forward<Args>(args)...) { (void)"This is nuts!"; }
        explicit Direction3D(const Position3D& from, const Position3D& to);
        AngleRadians toAngle() const;
        AngleRadians toPolarAngle() const;
        Position3D getpos() const { return Position3D(m_x, m_y, m_z); }

        //Direction3D getUpVector();
        //RotationMatrix toRotationMatrix();
        operator AngleRadians() const { return toAngle(); }
        operator AngleDegrees() const { return AngleDegrees(toAngle()); }
    };


    class Velocity3D : public Vector3D {
    public:
        using Vector3D::operator*;
        //Initializers
        Velocity3D() {};
        Velocity3D(Vector3D other) : Vector3D(other) {};
        //Operators
        Velocity3D operator*(const std::chrono::duration<float>& time);

        //Functions

    };

    class RotationMatrix {
    public:
        Vector3D right;
        Vector3D up;
        Vector3D forward;
    };


}
