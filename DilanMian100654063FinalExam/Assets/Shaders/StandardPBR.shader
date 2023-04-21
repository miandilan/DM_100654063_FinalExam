Shader "Custom/StandardPBR"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)//standard properties
        _MetallicTex ("Metallic (R)", 2D) = "white" {}
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "Queue"="Geometry" }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard 

        sampler2D _MetallicTex;

        struct Input
        {
            float2 uv_MetallicTex;//the uv coords of the texture are outputted
        };

        half _Metallic;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)//final output effect
        {
            o.Albedo = _Color.rgb;//the albedo has our colors for each pixel
            o.Smoothness = tex2D (_MetallicTex, IN.uv_MetallicTex).r;//smoothness is applied ot each uv coord
            o.Metallic = _Metallic;//metallic effect in place
        }
        ENDCG
    }
    FallBack "Diffuse"
}
