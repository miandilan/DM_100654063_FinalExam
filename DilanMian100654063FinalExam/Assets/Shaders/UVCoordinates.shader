Shader "Custom/UVCoordinates"
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

                struct appdata {// Define the appdata struct which represents the input vertex data
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct v2f {//Define the v2f struct which represents the output vertex data of the uv texture coordinates and vertex positions of
                    float2 uv : TEXCOORD0;                                                                                            //the texture.
                    float4 vertex : SV_POSITION;
                };

                sampler2D _MainTex;//Define a texture sampler property called "_MainTex"

                v2f vert(appdata v) { //The vertex function, which transforms the input vertex data and outputs the modified vertex data
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);//Transform the vertex into clip space
                    o.uv = v.uv;//Transform the uv coordinates
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target {//The fragment function, which calculates the color of each pixel
                    fixed3 debugColor = fixed3(i.uv, 0.0);//Set the pixel color to the vertex's texture coordinates, with 0 for the blue component
                    return fixed4(debugColor, 1.0);//Set the alpha component to 1.0 to make the texture opaque
                }
                ENDCG
            }
    }
}
