Shader "Alvaro/Custom/Bloom"
{
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
	}

    CGINCLUDE
		#include "UnityCG.cginc"

		sampler2D _MainTex, _SourceTex;
		float4 _MainTex_TexelSize;

		half _Threshold;
		half _Intensity;


		struct VertexData {//Input vertex info
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
		};

		struct Interpolators {//Output vertex info
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
		};

		Interpolators VertexProgram (VertexData v) {//transform vertex positions to clip space from object space and pass through the texture coords
			Interpolators i;
			i.pos = UnityObjectToClipPos(v.vertex);
			i.uv = v.uv;
			return i;
		}
		
		half3 Sample(float2 uv) {//sample the colors for each uv coord of the texture image
			return tex2D(_MainTex, uv).rgb;
		}
		//box filtering takes 4 samples instead of one, provides the averages of them (2x2 pixel blocks)by summing then divide by 4
		half3 SampleBox(float2 uv, float delta) {
			float4 o = _MainTex_TexelSize.xyxy * float2(-delta, delta).xxyy;//adjust the uv delta thats used to select sample points
			half3 s =
				Sample(uv + o.xy) + Sample(uv + o.zy) +
				Sample(uv + o.xw) + Sample(uv + o.zw);
			return s * 0.25f;
		}

		half3 Prefilter(half3 c) {//this will handle the threshold which determines which pixels contribute to the bloom effect
			half brightness = max(c.r, max(c.g, c.b));
			half contribution = max(0, brightness - _Threshold);//get the contribution of the color by subtractin threshold from its brightness
			contribution /= max(brightness, 0.00001);//set the color's max component to determine its brightness
			return c * contribution;
		}
	ENDCG

	SubShader {
		Cull Off
		ZTest Always
		ZWrite Off

		Pass { // 0 This is the boxdown prefilter pass
			CGPROGRAM
				#pragma vertex VertexProgram
				#pragma fragment FragmentProgram

				half4 FragmentProgram(Interpolators i) : SV_Target {
					return half4(Prefilter(SampleBox(i.uv, 1)), 1);
				}
			ENDCG
		}

		Pass {//1
			CGPROGRAM
				#pragma vertex VertexProgram
				#pragma fragment FragmentProgram
				half4 FragmentProgram(Interpolators i) : SV_Target {
		//					return tex2D(_MainTex, i.uv) * half4(1, 0, 0, 0);
							return half4(SampleBox(i.uv,1), 1);//using the box sampling here
						}
			ENDCG
		}
		Pass {//2
			Blend One One

			CGPROGRAM
				#pragma vertex VertexProgram//this pass covers 3x3 pixels
				#pragma fragment FragmentProgram
				half4 FragmentProgram(Interpolators i) : SV_Target {
								return half4(SampleBox(i.uv,0.5), 1);
											}
			ENDCG
		}
		Pass {//3
			CGPROGRAM
				#pragma vertex VertexProgram//this pass uses the default blend mode
				#pragma fragment FragmentProgram

				half4 FragmentProgram(Interpolators i) : SV_Target {
					half4 c = tex2D(_SourceTex, i.uv);
					c.rgb += _Intensity * SampleBox(i.uv, 0.5);//This includes controlling the intensity
					return c;
				}
			ENDCG
		}
		Pass {//4 This is for debugging
			CGPROGRAM
				#pragma vertex VertexProgram
				#pragma fragment FragmentProgram

				half4 FragmentProgram(Interpolators i) : SV_Target {
					return half4(_Intensity * SampleBox(i.uv, 0.5), 1);//This includes controlling the intensity
				}
			ENDCG
		}
	}
}
