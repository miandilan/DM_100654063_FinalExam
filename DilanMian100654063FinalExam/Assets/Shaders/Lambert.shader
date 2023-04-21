Shader "Custom/Lambert"
{
    Properties
    {
        _Color("Color", Color) = (1.0,1.0,1.0)//only color is needed here
    }
        SubShader
    {
        Tags { "LightMode" = "ForwardBase" }
        Pass{
            CGPROGRAM
            #pragma vertex vert//compiling the vertex and fragment shaders
            #pragma fragment frag
            //user-defined variables
            uniform float4 _Color;
            //unity defined variables
            uniform float4 _LightColor0;
            //base input structs
            struct vertexInput {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };
            
            struct vertexOutput {
                float4 pos: SV_POSITION;//the position and color being outputted here
                float4 col: COLOR;
            };

            //vertex functions
            vertexOutput vert(vertexInput v) {
                vertexOutput o;//the vertex shader output will use the normal direction of the object, the light direction, and attenuation
                float3 normalDirection = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
                float3 lightDirection;
                float atten = 1.0;

                //We normalize to get values 
                /*between - 1 and + 1 (i.e., unit
                    vector).
                    Provides the light direction in
                    world space*/
                lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 diffuseReflection = atten//atten gives strength of the light on the surface, the max is also used to prevent light on the vertex positions
                    * _LightColor0.xyz * _Color.rgb * max(0.0, dot(normalDirection, lightDirection));//creating a diffuse type of reflection with the dot product gives the intensity
                o.col = float4(diffuseReflection, 1.0);//the color for each vertex spawned from the diffuse reflection
                o.pos = UnityObjectToClipPos(v.vertex);//the position of each vertex
                return o;

            }

            //fragment function
            float4 frag(vertexOutput i) : COLOR//outputting the color for each fragment
            {
                return i.col;
            }

            ENDCG
        }
    }
    Fallback "Diffuse"
}
