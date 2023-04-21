Shader "Custom/ToonNormal"{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)//our standard properties
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "bump" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.0
        _Ramp("Toon Ramp", 2D) = "white" {}
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _Ramp;
        sampler2D _MainTex;
        sampler2D _NormalMap;
        float4 _Color;

        struct Input {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float3 worldNormal;
            float3 worldPos;
            INTERNAL_DATA
        };

        half4 LightingRamp(SurfaceOutput s, half3 lightDir, half atten) {
            half NdotL = dot(s.Normal, lightDir);//dot product of the surface normal and light direction, its the cosine angle between them
            half diff = NdotL * 0.5 + 0.5;//diffuse lighting 
            half3 ramp = tex2D(_Ramp, float(diff)).rgb;//ramp effect with the colors of the diffuse lighting
            half4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * ramp * atten;//the creation of the final outputted colors
            c.a = s.Alpha;
            return c;
        }

        void surf(Input IN, inout SurfaceOutput o) {
            // Sample the textures and combine them with the color property
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * _Color.rgb;
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_BumpMap));

            // Apply the toon ramp shading
            half3 worldNormal = normalize(mul(IN.worldNormal, (float3x3)UNITY_MATRIX_IT_MV));
            half3 worldPos = mul(IN.worldPos, unity_ObjectToWorld);
            SurfaceOutput s = (SurfaceOutput)0;
            s.Normal = worldNormal;
            s.Albedo = o.Albedo;
            s.Alpha = o.Alpha;
            s.Specular = 0.0;
            o.Emission = LightingRamp(s, _WorldSpaceLightPos0.xyz, 1.0);

            // Set the glossiness and metallic properties
            //o.Metallic = _Metallic;
            //o.Smoothness = _Glossiness;
        }
        ENDCG
    }
        FallBack "Diffuse"
}
