varying float vDistort;

uniform float uTime;
uniform float uSpeed;
uniform float uNoiseDensity;
uniform float uNoiseStrength;
uniform float uFrequency;
uniform float uAmplitude;

#pragma glslify: pnoise = require(glsl-noise/periodic/3d)
#pragma glslify: rotateY = require(glsl-rotate/rotateY)

void main() {
    float t = uTime * uSpeed;
    // You can also use classic perlin noise or simplex noise,
    // I'm using its periodic variant out of curiosity
    float distortion = pnoise((normal + t), vec3(10.0) * uNoiseDensity) * uNoiseStrength;

    // Disturb each vertex along the direction of its normal
    vec3 pos = position + (normal * distortion);

    // Create a sine wave from top to bottom of the sphere
    // To increase the amount of waves, we'll use uFrequency
    // To make the waves bigger we'll use uAmplitude
    float angle = sin(uv.y * uFrequency + t) * uAmplitude;
    pos = rotateY(pos, angle);

    vDistort = distortion; // Train goes to the fragment shader! Tchu tchuuu

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}
