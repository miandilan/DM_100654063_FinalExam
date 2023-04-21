Shader "Custom/SimpleSpecular"
{
    Properties
    {
        _Color ("Color", Color) = (0,0,0,0)//standard properties that are needed
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
            Tags { "RenderType" = "Opaque" }//This isn't transparent and can't be seen through
         CGPROGRAM
    #pragma surface surf SimpleSpecular

    half4 LightingSimpleSpecular(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
        half3 h = normalize(lightDir + viewDir);//halfway vector 

        half diff = max(0, dot(s.Normal, lightDir));//diffuse eq'n

        float nh = max(0, dot(s.Normal, h));//specular lighting
        float spec = pow(nh, 48.0);

        half4 c;//creating the formation of the colors
        c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
        c.a = s.Alpha;
        return c;
    }

    struct Input {
        float2 uv_MainTex;//outputting the uv coords themselves
    };

    sampler2D _MainTex;
    float4 _Color;

    void surf(Input IN, inout SurfaceOutput o) {//outputting our colors for the texture and its uv coords through the texture albedo
        o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * _Color.rgb;
    }
    ENDCG
    }
    FallBack "Simple Specular"
}
