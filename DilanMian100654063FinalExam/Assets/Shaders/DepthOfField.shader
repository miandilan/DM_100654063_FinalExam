Shader "Custom/DepthOfField"
{
	Properties{
		 _MainTex("Texture", 2D) = "white" {}
	}

		CGINCLUDE
#include "UnityCG.cginc"

	sampler2D _MainTex, _CameraDepthTexture, _CoCTex, _DoFTex;
	float4 _MainTex_TexelSize;

	float _BokehRadius, _FocusDistance, _FocusRange;
	int _FarSighted;

	struct VertexData {//These are our input vertex data of the vertex positions and uv coords for each one
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
	};

	struct Interpolators {//this is the vertex shader output of the vertex clip space position and the uv coords for each
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
	};

	Interpolators VertexProgram(VertexData v) {//vertex shader which converts our vertex's object space positions to clip space and returns our uv coords too
		Interpolators i;
		i.pos = UnityObjectToClipPos(v.vertex);
		i.uv = v.uv;
		return i;
	}

	ENDCG

		SubShader{
			Cull Off//disable backface culling
			ZTest Always//ensures pixels are 24/7 rendered based on their respective distance from the camera
			ZWrite Off//disable depth writing which updates the depth/z buffer with the distance of each pixel from the camera

		Pass { // 0 circleOfConfusionPass
			CGPROGRAM
				#pragma vertex VertexProgram
				#pragma fragment FragmentProgram

		    //half4
			half FragmentProgram(Interpolators i) : SV_Target {
				float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
				depth = LinearEyeDepth(depth);
				
				float coc = (depth - _FocusDistance) / _FocusRange;
				coc = clamp(coc, -1, 1) * _BokehRadius;
				//if (coc < 0) {
				//return coc * -half4(1, 0, 0, 1);
				//}
				return coc;
			}
					ENDCG
			}
		//Pass 0 uses the vertex program and fragment program to get the circle of confusion for all the pixels based on their depth, range, and focus distance. 
	    //The value circle of confusion value is then clamped and multiplied by the bokehradius. This blurs the image.

		Pass { // 1 preFilterPass
			CGPROGRAM
				#pragma vertex VertexProgram
				#pragma fragment FragmentProgram

				half4 FragmentProgram(Interpolators i) : SV_Target {
					float4 o = _MainTex_TexelSize.xyxy * float2(-0.5, 0.5).xxyy;
					half coc0 = tex2D(_CoCTex, i.uv + o.xy).r;
					half coc1 = tex2D(_CoCTex, i.uv + o.zy).r;
					half coc2 = tex2D(_CoCTex, i.uv + o.xw).r;
					half coc3 = tex2D(_CoCTex, i.uv + o.zw).r;

					//half coc = (coc0 + coc1 + coc2 + coc3) * 0.25;
					half cocMin = min(min(min(coc0, coc1), coc2), coc3);
					half cocMax = max(max(max(coc0, coc1), coc2), coc3);
					half coc = cocMax >= -cocMin ? cocMax : cocMin;

					return half4(tex2D(_MainTex, i.uv).rgb, coc);
				}
			ENDCG
		}
        //Pass 1 uses the vertex and fragment programs to pre-filter the picture. The fragment one gets the circle of confusion values for all the pixels and 
		//in a 2x2 grid. It then returns the min and max values. These 2 values are used to calculate the final circle of confusion for the pixel, which is 
	    //returned; the color of the pixel is returned too.

		Pass {//2 bokehPass
			CGPROGRAM
				#pragma vertex VertexProgram
				#pragma fragment FragmentProgram
				
				#define BOKEH_KERNEL_MEDIUM
				// From https://github.com/Unity-Technologies/PostProcessing/
				// blob/v2/PostProcessing/Shaders/Builtins/DiskKernels.hlsl
				
				#if defined(BOKEH_KERNEL_SMALL)
				static const int kernelSampleCount = 16;
				static const float2 kernel[kernelSampleCount] = {
					float2(0, 0),
					float2(0.54545456, 0),
					float2(0.16855472, 0.5187581),
					float2(-0.44128203, 0.3206101),
					float2(-0.44128197, -0.3206102),
					float2(0.1685548, -0.5187581),
					float2(1, 0),
					float2(0.809017, 0.58778524),
					float2(0.30901697, 0.95105654),
					float2(-0.30901703, 0.9510565),
					float2(-0.80901706, 0.5877852),
					float2(-1, 0),
					float2(-0.80901694, -0.58778536),
					float2(-0.30901664, -0.9510566),
					float2(0.30901712, -0.9510565),
					float2(0.80901694, -0.5877853),
				};
				#elif defined (BOKEH_KERNEL_MEDIUM)
				static const int kernelSampleCount = 22;
				static const float2 kernel[kernelSampleCount] = {
					float2(0, 0),
					float2(0.53333336, 0),
					float2(0.3325279, 0.4169768),
					float2(-0.11867785, 0.5199616),
					float2(-0.48051673, 0.2314047),
					float2(-0.48051673, -0.23140468),
					float2(-0.11867763, -0.51996166),
					float2(0.33252785, -0.4169769),
					float2(1, 0),
					float2(0.90096885, 0.43388376),
					float2(0.6234898, 0.7818315),
					float2(0.22252098, 0.9749279),
					float2(-0.22252095, 0.9749279),
					float2(-0.62349, 0.7818314),
					float2(-0.90096885, 0.43388382),
					float2(-1, 0),
					float2(-0.90096885, -0.43388376),
					float2(-0.6234896, -0.7818316),
					float2(-0.22252055, -0.974928),
					float2(0.2225215, -0.9749278),
					float2(0.6234897, -0.7818316),
					float2(0.90096885, -0.43388376),
				};
				#endif

				half Weigh(half coc, half radius) {
					//return coc >= radius;
					return saturate((coc - radius + 2) / 2);

				}

				half4 FragmentProgram(Interpolators i) : SV_Target {
					half coc = tex2D(_MainTex, i.uv).a;
				half3 bgColor = 0, fgColor = 0;
				half bgWeight = 0, fgWeight = 0;
				for (int k = 0; k < kernelSampleCount; k++) {
					float2 o = kernel[k] * _BokehRadius;
					half radius = length(o);
					o *= _MainTex_TexelSize.xy;
					half4 s = tex2D(_MainTex, i.uv + o);

					half bgw = Weigh(max(0, s.a), radius);
					bgColor += s.rgb * bgw;
					bgWeight += bgw;

					half fgw = Weigh(-s.a, radius);
					fgColor += s.rgb * fgw;
					fgWeight += fgw;
				}
				bgColor *= 1 / (bgWeight + (bgWeight == 0));
				fgColor *= 1 / (fgWeight + (fgWeight == 0));
				//half bgfg = min(1, fgWeight / kernelSampleCount);
				half bgfg =
					min(1, fgWeight * 3.14159265359 / kernelSampleCount);
				half3 color = lerp(bgColor, fgColor, bgfg);
				return half4(color, bgfg);
				}
			ENDCG
		}
		//Pass 2 uses the vertex and fragment shaders to make a kernel shaped like a disk for every pixel on the image. This kernel is then defined by an 
	    //array of float2 values, and the fragment shader uses the kernel to blur the picture depending on the circle of confusion values calculated in the 
		//earlier passes.

		Pass {//3 postFilterPass
			CGPROGRAM
				#pragma vertex VertexProgram
				#pragma fragment FragmentProgram

				half4 FragmentProgram(Interpolators i) : SV_Target {
					float4 o = _MainTex_TexelSize.xyxy * float2(-0.5, 0.5).xxyy;
					half4 s =
						tex2D(_MainTex, i.uv + o.xy) +
						tex2D(_MainTex, i.uv + o.zy) +
						tex2D(_MainTex, i.uv + o.xw) +
						tex2D(_MainTex, i.uv + o.zw);
					return s * 0.25;
				}
			ENDCG
		}
        //Pass 3 above applies the post-processing filter to the blurred image made by the bokeh pass. This removes left over artifacts and noise from the image. 
		//Therefore, the depth of field effect is much cleaner. This pass smooths out the image while keeping the edges of the surfaces, It utilizes the spatial
	    //kernel size and range kernel size. The former finds how far the filter searches for nearby pixels to smooth, while the range kernel size gets the amount
	    //of variation in pixel intensity to be allowed before an edge is considered to be present.

		Pass{//4 combinePass
			CGPROGRAM
				#pragma vertex VertexProgram
				#pragma fragment FragmentProgram

				half4 FragmentProgram(Interpolators i) : SV_Target {
					half4 source = tex2D(_MainTex, i.uv);
					half coc = tex2D(_CoCTex, i.uv).r;
					half4 dof = tex2D(_DoFTex, i.uv);

					// coc is multiplied by _Farsighted to determine which side of the focus distance is in focus
					// What this does is invert the depth map (i.e. where black is white, and white is black)

					half dofStrength = smoothstep(0.1, 1, coc * _FarSighted); 
					half3 color = lerp(
						source.rgb, dof.rgb,
						dofStrength + dof.a - dofStrength * dof.a
					);
					return half4(color, source.a);
					//return coc * _FarSighted;
				}
			ENDCG
		}
		//Pass 4 combines the post-filtered and blury image with the original to make the final amount of depth of the depth of field effect. It blends the 
	    //blurred and unblurred parts of the image to copy how our eyes see things in a depth of field. To get here, the original image from the pass 0 is 
	    //blended with the blurred one. Then the blending operation is usually a simple linear lerp that blends these 2 pictures depending on their weighting 
		//factor. This factor is obtained from the distance between the pixel's depth value and focal depth value. Pixels that are closer to the focal depth have
		//more weight in the blending operation, while farther pixels have less weight. The output of this is the final image with the depth of field effect 
		//applied in all it's realistic appeal.
	}
}
