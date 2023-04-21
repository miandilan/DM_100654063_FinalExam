Shader "Custom/BlinnPhong"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)//Our only needed property
    }
        SubShader
    {
        Tags { "Queue" = "Geometry" }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf BasicBlinn

        half4 LightingBasicBlinn(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
              half3 h = normalize(lightDir + viewDir);//halfway vector being used which is the normalized sum of the light and view directions.
              half diff = max (0, dot(s.Normal, lightDir));//diffuse eq'n.
              float nh = max(0, dot(s.Normal, h));//This and the line below create our specular light.
              float spec = pow(nh, 48.0);

              half4 c;//Defines our color of the shader
              c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
              c.a = s.Alpha;
              return c;
        }

        struct Input
        {
            float2 uv_MainTex;//uv coordinates of the texture being used for the output
        };

        float4 _Color;


        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Color.rgb;//outputting our colors through the albedo
        }
        ENDCG
    }
        FallBack "Diffuse"
}
