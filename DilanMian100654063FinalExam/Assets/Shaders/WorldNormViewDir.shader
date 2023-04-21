Shader "Custom/WorldNormViewDir"
{
    Properties{
        _MainTex("Texture", 2D) = "white" {}
    }

        SubShader{
            Tags { "RenderType" = "Opaque" }

            Pass {
                CGPROGRAM
                #pragma vertex vert//Tell the shader compiler to use "vert" as the vertex shader function
                #pragma fragment frag//Tell the shader compiler to use "frag" as the fragment shader function

                struct appdata {//Define the input structure for the vertex shader, which includes the vertex position, normal, and world position
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float3 worldPos : TEXCOORD0;
                };

                struct v2f {//Define the output structure for the vertex shader, which includes the normal, world position, view direction, and vertex position
                    float3 normal : TEXCOORD0;
                    float3 worldPos : TEXCOORD1;
                    float3 viewDir : TEXCOORD2;
                    float4 vertex : SV_POSITION;
                };

                float4 _Color;//Define a color property named "_Color" for the shader

                //Define the vertex shader function, which transforms the vertex position, normal, and world position to output the normal, world position, 
                //view direction, and vertex position for each vertex
                v2f vert(appdata v) {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);//Transform the vertex position to clip space
                    o.normal = mul(float4(v.normal, 0.0), unity_WorldToObject).xyz;//Transform the normal from world space to object space
                    o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;//Transform the world position from object space to world space
                    o.viewDir = normalize(_WorldSpaceCameraPos - o.worldPos);//Calculate the view direction from the camera position and the world position
                    return o;
                }
                //Define the fragment shader function, which calculates the dot product of the normal and view direction
                //for each pixel and outputs a grayscale color based on the dot product
                fixed4 frag(v2f i) : SV_Target {
                    float dotProduct = dot(i.normal, i.viewDir);//Calculate the dot product of the normal and view direction
                    fixed3 debugColor = fixed3(dotProduct, dotProduct, dotProduct);//Create a grayscale color based on the dot product
                    return fixed4(debugColor, 1.0);//Output the grayscale color with alpha set to 1.0
                }
                ENDCG
            }
        }
}
