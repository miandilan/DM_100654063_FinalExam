Shader "Custom/WorldPos"
{
    Properties{
         _MainTex("Texture", 2D) = "white" {}
    }

        SubShader{//SubShader block is where we define the rendering behavior for different render types
            Tags { "RenderType" = "Opaque" }

            Pass {//Pass block is where we define how we want to render our object
                CGPROGRAM//We need to tell the graphics card which functions to use as our vertex and fragment shaders
                #pragma vertex vert
                #pragma fragment frag

                struct appdata {
                    float4 vertex : POSITION;//Define the input structure for our vertex shader
                };

                struct v2f {//Define the output structure for our vertex shader
                    float3 worldPos : TEXCOORD0;
                    float4 vertex : SV_POSITION;
                };

                float4 _Color;//Define a color property for the shader

                //The vertex shader transforms the vertices of our mesh from object space to clip space and outputs the world position of each vertex
                v2f vert(appdata v) {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                    return o;
                }

                //The fragment shader takes in the interpolated output from the vertex shader and outputs the world position of each pixel
                fixed4 frag(v2f i) : SV_Target {
                    fixed3 debugColor = i.worldPos;
                    return fixed4(debugColor, 1.0);
                }
                ENDCG
            }
        }
}
