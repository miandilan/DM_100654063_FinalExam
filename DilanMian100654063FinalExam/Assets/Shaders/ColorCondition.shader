Shader "Custom/ColorCondition"
{
    Properties{
        _MainTex("Texture", 2D) = "white" {}//Define a texture property with default value "white"
    }

        SubShader{
            Tags { "RenderType" = "Opaque" }

            Pass {
                CGPROGRAM //Use the vertex and fragment functions defined below
                #pragma vertex vert
                #pragma fragment frag

                struct appdata {
                    float4 vertex : POSITION;//Define the appdata struct which represents the input vertex data
                };

                struct v2f {//Define the v2f struct which represents the output vertex data of the texture coordinates world position and vertex positions of
                    float3 worldPos : TEXCOORD0;                                                                                         //the texture.
                    float4 vertex : SV_POSITION;
                };

                float4 _Color;//Define a color property called "_Color"

                v2f vert(appdata v) {//The vertex function, which transforms the input vertex data and outputs the modified vertex data
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);//Transform the vertex into clip space
                    o.worldPos = mul(unity_ObjectToWorld, v.vertex);//Transform the vertex into world space
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target {//The fragment function, which calculates the color of each pixel
                    fixed4 debugColor;
                    if (i.worldPos.y < 0) {//Check if the pixel's world position on the y axis is below 0
                        debugColor = float4(1, 1, 0, 0);//Set pixel color to yellow
                    }
                    else {
                        debugColor = float4(0, 1, 1, 0);//Otherwise make the color cyan.
                    }
                    return debugColor;
                }
                ENDCG
            }
        }
}
