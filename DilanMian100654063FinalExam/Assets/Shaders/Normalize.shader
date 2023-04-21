Shader "Custom/Normalize"
{
    Properties{
         _MainTex("Texture", 2D) = "white" {}
    }

        SubShader{
            Tags { "RenderType" = "Opaque" }

            Pass {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                struct appdata {//Define the appdata structure to hold vertex information
                    float4 vertex : POSITION;
                };

                struct v2f {//Define the v2f structure to hold data sent from the vertex shader to the fragment shader
                    float3 worldPos : TEXCOORD0;//World position of the vertex's texture coords
                    float4 vertex : SV_POSITION;//Clip position of the vertex
                };

                float4 _Color;

                v2f vert(appdata v) {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);//Convert vertex position from object space to clip space
                    o.worldPos = normalize(mul(unity_ObjectToWorld, v.vertex));//Calculate the world position of the vertex and normalize it
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target {
                    fixed3 debugColor = i.worldPos;//Declare a variable to hold the debug color
                    return fixed4(debugColor, 1.0);//Return the debug color as a fixed4 with alpha = 1.0
                }
                ENDCG
            }
    }
}
