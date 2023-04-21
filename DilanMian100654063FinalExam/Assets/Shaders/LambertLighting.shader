Shader "Custom/LambertLighting"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf BasicLambert 

        half4 LightingBasicLambert(SurfaceOutput s, half3 lightDir, half atten) {
              half NdotL = dot(s.Normal, lightDir);//the dot product of the surface normal and the light direction
              half4 c;
              c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);//the creation of our colors 
              c.a = s.Alpha;
              return c;
        }

        struct Input
        {
            float2 uv_MainTex;//the outputted uv coords of the texture
        };

        float4 _Color;


        void surf (Input IN, inout SurfaceOutput o)//outputs the albedo to have the color on each pixel
        {
            o.Albedo = _Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
