Shader "Custom/Diffuse"
{
    Properties{
            _MainTex("Texture", 2D) = "white" {}//the texture itself with a set color of white
    }
        SubShader{
        Tags { "RenderType" = "Opaque" }
        CGPROGRAM
          #pragma surface surf SimpleLambert//compiling the simple lambert type of surface shader

          half4 LightingSimpleLambert(SurfaceOutput s, half3 lightDir, half atten) {
              half NdotL = dot(s.Normal, lightDir);//the dot product of the surface normal and light direction
              half4 c;
              c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);//defines our color coordinates appearance
              c.a = s.Alpha;//connecting the colors to be affected by transparency
              return c;
          }

        struct Input {
            float2 uv_MainTex;//inputting the textures uv coords
        };

        sampler2D _MainTex;

        void surf(Input IN, inout SurfaceOutput o) {//the albedo is our colors for each uv coordinate of the texture
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }
        Fallback "Diffuse"
}
