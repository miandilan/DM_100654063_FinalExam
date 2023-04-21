Shader "Custom/Shadow-Shader"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _ShadowTex("Shadow Texture", 2D) = "white" {}
        _Intensity("Intensity", Range(0,1)) = 0.5
        _LineCount("LineCount", Range(0,100)) = 30
        _ShadowColor("Shadow Color", Color) = (0,0,0,1)
        
    }
        SubShader{

            Pass
            {
                Tags {"LightMode" = "ForwardBase"}

                CGPROGRAM
                #pragma vertex vert// Using the fragment and vertex shaders
                #pragma fragment frag
                
                // Multi-compile directive for forward rendering path with no lightmaps, directional lightmaps, and no dynamic lightmaps or vertex lighting
                #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
                #include "UnityCG.cginc"// Include Unity's CG include files for general functions and lighting calculation
                #include "UnityLightingCommon.cginc"
                #include "Lighting.cginc"
                #include "AutoLight.cginc"

                struct appdata {// Define the appdata structure to hold vertex information
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float4 texcoord : TEXCOORD0;
                };

                struct v2f {// Define the v2f structure to hold data sent from the vertex shader to the fragment shader
                    float2 uv : TEXCOORD0;
                    fixed4 diff : COLOR0;
                    float4 pos : SV_POSITION;
                    SHADOW_COORDS(1)
                        //SHADOW COORDS
                };

                        v2f vert(appdata v) {//the vertex shader function
                            v2f o;
                            o.pos = UnityObjectToClipPos(v.vertex);
                            o.uv = v.texcoord;//set the uv coords

                            half3 worldNormal = UnityObjectToWorldNormal(v.normal);//convert vertex normals from object to clip space
                            half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));// Calculate the dot product between the world normal and the world light position to determine light intensity
                            o.diff = nl * _LightColor0;//diffuse color
                            TRANSFER_SHADOW(o);//set the shadow coords

                            return o;//return output
                        }

                        sampler2D _MainTex;
                        float4 _Color;
                        sampler2D _ShadowTex;
                        float4 _ShadowColor;
                        float _Intensity;
                        float _LineCount;

                        fixed4 frag(v2f i) : SV_Target
                        {
                            fixed4 baseColor = tex2D(_MainTex, i.uv) * _Color;// Sample the main texture and apply the color property
                        fixed shadow = SHADOW_ATTENUATION(i);
                        //baseColor.rgb *= i.diff;
                        fixed4 shadowTex = tex2D(_ShadowTex, i.uv * _LineCount);
                        fixed4 finalCol = baseColor * shadow + ((shadowTex * baseColor * _Intensity) * (1 - shadow));// Apply the shadow color and intensity to the diffuse color
                        return finalCol;// Return the final color
                        }
                    ENDCG
            }


                    Pass
                    {
                        Tags {"LightMode" = "ShadowCaster"}

                        CGPROGRAM
                        #pragma vertex vert
                        #pragma fragment frag
                        #pragma multi_compile_shadowcaster
                        #include "UnityCG.cginc"

                        struct appdata {//vertex shader takes appdata structure as input, which includes the vertex position, normal, and texture coordinates. 
                            float4 vertex : POSITION;
                            float3 normal : NORMAL;
                            float4 texcoord : TEXCOORD0;
                        };

                        struct v2f {//The shader outputs a v2f structure, which includes the position of the vertex in screen space and shadow coordinates.
                            V2F_SHADOW_CASTER;

                        };
                        
            
                        v2f vert(appdata v) {
                            v2f o;
                            TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)//necessary for shadow casting
                            return o;
                        }

                        float4 frag(v2f i) : SV_Target{


                            SHADOW_CASTER_FRAGMENT(i)//set the output color to the value of the shadow being cast.


                        }
                        ENDCG
                    }
        }
}
