Shader "Custom/ViewDir"
{
    Properties{
         _MainTex("Texture", 2D) = "white" {}
    }

        SubShader{
            Tags { "RenderType" = "Opaque" }

            Pass {
                CGPROGRAM// Declare the vertex and fragment shaders to be used
                #pragma vertex vert
                #pragma fragment frag

                struct appdata {// Declare the input vertex data structure
                    float4 vertex : POSITION;// Vertex position in homogeneous coordinates
                    float3 normal : NORMAL;// Normal vector of the surface at this vertex
                    float3 worldPos : TEXCOORD0;// World space position of the vertex
                };

                struct v2f {// Declare the output vertex data structure
                    float3 viewDir : TEXCOORD0;// The view direction from the camera to the vertex
                    float4 vertex : SV_POSITION;// Vertex position in clip space
                };

                float4 _Color;//Declare color properties

                v2f vert(appdata v) {//Define the vertex shader
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);// Transform the vertex position to clip space
                    o.viewDir = normalize(_WorldSpaceCameraPos.xyz - v.worldPos);// Calculate the view direction from the camera to the vertex
                    return o;
                }
                // Define the fragment shader
                fixed4 frag(v2f i) : SV_Target {
                    fixed3 debugColor = i.viewDir;// Use the view direction as the debug color
                    return fixed4(debugColor, 1.0);// Return the debug color with an alpha of 1.0
                }
                ENDCG
            }
        }
}
