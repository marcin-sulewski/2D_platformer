shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0; // 0 = otwarte, 1 = zamknięte
uniform float turns = 5.0; // ilość zwojów spirali
uniform float pixel_step = 0.03; // pikselowy próg (mniejsze = więcej szczelin)

void fragment() {
    // Centrum ekranu = (0,0), reszta -1..1
    vec2 uv = SCREEN_UV * 2.0 - vec2(1.0);

    float radius = length(uv);
    float angle = atan(uv.y, uv.x); // -PI do PI
    float normalized_angle = (angle + 3.141592) / (2.0 * 3.141592); // 0..1

    // spiralna maska — wycięcie od środka
    float spiral = turns * radius + normalized_angle;

    // przeskok co X kroków — pikselowy styl
    float stepped = floor(spiral / pixel_step) * pixel_step;

    // czarna maska spiralna
    float mask = stepped < progress ? 1.0 : 0.0;

    COLOR = vec4(vec3(0.0), mask);
}
