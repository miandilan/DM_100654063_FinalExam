Shader "Custom/DistortionScript"
{
    Properties{
_MainTex("Texture", 2D) = "white" {}
_Distortion("Distortion", Range(-1, 1)) = 0.1
_Scale("Scale", Range(0, 10)) = 1
_Center("Center", Vector) = (0.5, 0.5, 0, 0)
_OffsetR("OffsetR", Range(-0.01, 0.01)) = 0.001//values for the rgb offsets
_OffsetG("OffsetG", Range(-0.01, 0.01)) = 0.001
_OffsetB("OffsetB", Range(-0.01, 0.01)) = -0.001
    }
        SubShader{
        Tags { "RenderType" = "Opaque" }
        LOD 100
        Pass {
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #include "UnityCG.cginc"
        struct appdata {
        float4 vertex : POSITION;
        float2 uv : TEXCOORD0;
        };
        struct v2f {
        float2 uv : TEXCOORD0;
        float4 vertex : SV_POSITION;
        };
        float _Distortion;
        float _Scale;
        float4 _Center;
        float _OffsetR;
        float _OffsetG;
        float _OffsetB;
        sampler2D _MainTex;
        v2f vert(appdata v) {
        v2f o;
        o.vertex = UnityObjectToClipPos(v.vertex);
        o.uv = v.uv;
        return o;
        }
        fixed4 frag(v2f i) : SV_Target {
        float2 center = _Center.xy;//center of the img
        float2 p = i.uv - center;//offset of each pixel from the center is calculated
        float r2 = dot(p, p);//The squared distance from the current pixel from the center is calculated using the dot product
        float2 distortion = p * (_Distortion * r2 + 1);//The distortion vector is obtained by multiplying the offset by a factor proportional to the squared
                                                       //distance (distortion property)
        float2 uv = center + distortion * _Scale;
        // Sample the texture three times with different offsets
        float2 offsetR = float2(_OffsetR, 0);
        float2 offsetG = float2(_OffsetG, 0);
        float2 offsetB = float2(_OffsetB, 0);
        float4 texR = tex2D(_MainTex, uv + offsetR);
        float4 texG = tex2D(_MainTex, uv + offsetG);
        float4 texB = tex2D(_MainTex, uv + offsetB);
        // Combine the color channels with different weights
        float3 color = float3(texR.r, texG.g, texB.b);
        color *= 1.5; // Increase the effect
        return fixed4(color, 1);
        return tex2D(_MainTex, uv);
        }
        ENDCG
        }
    }
FallBack "Diffuse"
}
