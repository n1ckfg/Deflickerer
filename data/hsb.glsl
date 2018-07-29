uniform vec3 iResolution;

uniform vec4 hsbc;

uniform sampler2D texture;

// https://forum.unity.com/threads/hue-saturation-brightness-contrast-shader.260649/

vec3 applyHue(vec3 aColor, float aHue) {
    float angle = radians(aHue);
    vec3 k = vec3(0.57735, 0.57735, 0.57735);
    float cosAngle = cos(angle);
    // Rodrigues' rotation formula
    return aColor * cosAngle + cross(k, aColor) * sin(angle) + k * dot(k, aColor) * (1 - cosAngle);
}
 
 
vec4 applyHSBEffect(vec4 startColor) { //, vec4 hsbc) {
    float _Hue = 360 * hsbc.r;
    float _Brightness = hsbc.g * 2 - 1;
    float _Contrast = hsbc.b * 2;
    float _Saturation = hsbc.a * 2;
 
    vec4 outputColor = startColor;
    outputColor.rgb = applyHue(outputColor.rgb, _Hue);
    outputColor.rgb = (outputColor.rgb - 0.5) * (_Contrast) + 0.5;
    outputColor.rgb = outputColor.rgb + _Brightness;      
    float intensityVal = dot(outputColor.rgb, vec3(0.299,0.587,0.114));
    vec3 intensity = vec3(intensityVal, intensityVal, intensityVal);
    outputColor.rgb = mix(intensity, outputColor.rgb, _Saturation);
 
    return outputColor;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
	vec2 uv = fragCoord.xy / iResolution.xy;

	vec4 col = texture2D(texture, uv);

	fragColor = applyHSBEffect(col);
}

void main() {
	mainImage(gl_FragColor, gl_FragCoord.xy);
}