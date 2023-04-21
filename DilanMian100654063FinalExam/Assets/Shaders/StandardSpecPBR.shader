Shader "Custom/StandardSpecPBR"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)//this time metallic will not be used in the subshader but it is in the properties
        _MetallicTex("Metallic (R)", 2D) = "white" {}
        _SpecColor("Specular", Color) = (1,1,1,1)//specular lighting color is set as a property
    }
        SubShader
        {
            Tags { "Queue" = "Geometry" }

            CGPROGRAM
            // Physically based Standard lighting model, and enable shadows on all light types
            #pragma surface surf StandardSpecular

            sampler2D _MetallicTex;

            struct Input
            {
                float2 uv_MetallicTex;//outputted are the uv texture coordinates
            };

            half _Metallic;
            fixed4 _Color;

            void surf(Input IN, inout SurfaceOutputStandardSpecular o)
            {
                o.Albedo = _Color.rgb;//the albedo is comprised of color for each pixel
                o.Smoothness = tex2D (_MetallicTex, IN.uv_MetallicTex).r;//smoothness for each uv coordinate
                o.Specular = _SpecColor.rgb;//specular lighting applied for the colors of the shader
            }
            ENDCG
        }
            FallBack "Diffuse"
}
