Shader "Custom/DiffuseWrap"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)//These are standard properties
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
            Tags { "RenderType" = "Opaque" }
        CGPROGRAM
    #pragma surface surf WrapLambert//This compiles our program as a wrap lambert surface shader

    half4 LightingWrapLambert(SurfaceOutput s, half3 lightDir, half atten) {
        half NdotL = dot(s.Normal, lightDir);//the dot product of the surface normal and light direction, it gets the cosine angle between em
        half diff = NdotL * 0.5 + 0.5;//diffuse lighting effect
        half4 c;//this and the 4 lines below are our final color values being defined with the previous eq'n, the surface albedo,
        c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten);//the light's color made from the surface albedo, light color, and diffuse intensity
        c.a = s.Alpha;//the alpha channel c is set to surface's alpha val
        return c;
    }

    struct Input {
        float2 uv_MainTex;//the uv coords of the texture are inputted
    };

    sampler2D _MainTex;//variable of the texture itself
    void surf(Input IN, inout SurfaceOutput o) {//the albedo will be outputting the colors of each texture uv coordinate
        o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
    }
    ENDCG
    }
    FallBack "Diffuse"
}
