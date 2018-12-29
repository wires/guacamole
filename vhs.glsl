precision mediump float;

uniform float iTime; //  = 0.0;

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(float prev, in vec2 fragCoord) {
    float noiseS = sin(8.0 * fragCoord.y);
    return prev * 0.9 + 0.1 * noiseS;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    float y = 0.1 * fragCoord.y + 40.0 * iTime;
    float n = pow(sin(y * 0.1) * 0.6 + 0.6, 5.0);
    vec4 stripes = vec4(0.9 * n, 0.3 * n, 0.97 * n, 1.0);

    float noize = pow(rand(iTime / 5000.0 + fragCoord), 6.0);
    noize = noise(noize, fragCoord);
    noize = noise(noize, fragCoord);
    noize = noise(noize, fragCoord);
    noize = noise(noize, fragCoord);
    noize = noise(noize, fragCoord);
    noize = noise(noize, fragCoord);
    noize = noise(noize, fragCoord);

    float noize2 = noise(noize, fragCoord);

	fragColor = (0.9 * noize2 * stripes) + 0.3 * noize;
}

void trippy(out vec4 fragColor, in vec2 fragCoord) {
  float time = iTime * 1.0;
  vec2 uv = (gl_FragCoord.xy / (500.0) - 0.5) * 8.0;
  vec2 uv0 = uv;
  float i0 = 1.0;
  float i1 = 1.0;
  float i2 = 1.0;
  float i4 = 0.0;
  for (int s = 0; s < 7; s++) {
    vec2 r;
    r = vec2(cos(uv.y * i0 - i4 + time / i1), sin(uv.x * i0 - i4 + time / i1)) / i2;
    r += vec2(-r.y, r.x) * 0.3;
    uv.xy += r;

    i0 *= 1.93;
    i1 *= 1.15;
    i2 *= 1.7;
    i4 += 0.05 + 0.1 * time * i1;
  }
  float r = sin(uv.x - time) * 0.5 + 0.5;
  float b = sin(uv.y + time) * 0.5 + 0.5;
  float g = sin((uv.x + uv.y + sin(time * 0.5)) * 0.5) * 0.5 + 0.5;
  fragColor = vec4(r, g, b, 1.0);
}

void main() {
    vec4 a = vec4(0,0,0,0);
    vec4 b = vec4(0,0,0,0);

    mainImage(a, gl_FragCoord.xy);
    trippy(b, gl_FragCoord.xy);

    gl_FragColor = vec4(a.x + b.x, a.y + b.y, a.z + b.z, 1);
}
