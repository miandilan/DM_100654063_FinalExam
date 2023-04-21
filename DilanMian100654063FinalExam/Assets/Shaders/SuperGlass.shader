Shader "Custom/SuperGlass"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}//texture
        _BumpMap("Normalmap", 2D) = "bump" {}//normal map texture
        _ScaleUV("Scale", Range(1, 20)) = 1//range for levels of distortion
    }
        SubShader//the shader's rendering behaviour
        {
            Tags { "Queue" = "Transparent" }//the shader will prioritize transparency
            GrabPass{}//stores a snapshot of the screen at a certain point to use later in the shader
            Pass
            {
                CGPROGRAM
                #pragma vertex vert//using the vertex and fragment shaders
                #pragma fragment frag

                #include "UnityCG.cginc"//provides unity-specific functions and variables

                struct appdata//the input data for the vertex shader
                {
                    float4 vertex : POSITION;//position for and uv coordinate for each vertex of the mesh
                    float2 uv : TEXCOORD0;
                };

                struct v2f//the output data for the vertex shader
                {
                    float2 uv : TEXCOORD0;//uv coords
                    float4 uvgrab : TEXCOORD1;//distorted uv coords
                    float2 uvbump : TEXCOORD2;//uv coords for the normal map
                    float4 vertex : SV_POSITION;//vertex position
                };

                sampler2D _GrabTexture;//variables to be used in the later functions of this shader
                float4 _GrabTexture_TexelSize;
                sampler2D _MainTex;
                float4 _MainTex_ST;
                sampler2D _BumpMap;
                float4 _BumpMap_ST;
                float _ScaleUV;

                v2f vert(appdata v)//vertex shader takes the input data
                {
                    v2f o;//output data to be manipulated
                    o.vertex = UnityObjectToClipPos(v.vertex);//this sets the vertex property o to the transformed vertex pos of the current vertex, passed
                                                              //the v var, the vertex pos is converted to clip space from object space
                    #if UNITY_UV_STARTS_AT_TOP//conditional pre-processor directive that checks if the UV coords start at the top or bottom of the texture
                    float scale = -1.0f;//this var is set to -1 if the UV coords start at the top or bottom of the texture
                    #else//this runs if the UV coords don't start at the top of the texture
                    float scale = 1.0f;//if what happens in the #else happens, then this var is set to 1
                    #endif

                    o.uvgrab.xy = (float2 (o.vertex.x, o.vertex.y * scale) + o.vertex.w) * 0.5;//this calculates the UV coords of the current vertex in screen
                                                                                               //space by taking the transformed x/y pos of the vertex, multiply
                                                                                               //y by scale to handle the different UV orientation, then add 
                                                                                               //transformed w component of vertex.  It then scales this value 
                                                                                               //by 0.5 to fit within the [0, 1] UV range and sets it as the 
                                                                                               //"uvgrab.xy" property of the output o.
                    o.uvgrab.zw = o.vertex.zw;//this sets the zw components of o.yvgrab to the transformed z and w vals of the current vertex
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);//this transforms the original UV coords of the current vertex using the main texture's S/T(scale/translate)
                                                         //vals and sets it as the uv property of the output o

                    o.uvbump = TRANSFORM_TEX(v.uv, _BumpMap);//transforms original uv coords of the current vertex using the bumpmap texture's ST vals and sets it
                                                             //as the uvbump property of o
                    return o;//returns the output with transformed vertex and uv coords
                }

                fixed4 frag(v2f i) : SV_Target//the current render target is location of storage for the output
                {
                    half2 bump = UnpackNormal(tex2D(_BumpMap, i.uvbump)).rg;//samples the normal map at the current uv coords i.uvbump, unpacks the normal from the
                                                                            //texture, and stores the red green channels of the norm in the bump var as 16-bit half floats
                    
                    float2 offset = bump * _ScaleUV * _GrabTexture_TexelSize.xy;//gets offset of the grab texture coords based on the sampled normal map, the scale
                                                                                //factor, and texel size in the grab texture. The offset's a 2d vector in uv space
                                                                                //that represents the displacement of the grabbed image relative to the current pixel
                    i.uvgrab.xy = offset * i.uvgrab.z + i.uvgrab.xy;//updates grab texture coords via applying computed offset, taking into account the depth val of
                                                                    //the current pixel (i.uvgrab.z), this allows the grabbed img to be distorted and refracted
                                                                    //based on the shape of the object

                    fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));//this samples the grab texture at the updated coords i.uvgrab and stores the 
                                                                                     //result in the col var as a fixed4 color var. The tex2Dproj does a perspective
                                                                                     //correct sampling of the texture using the current projection matrix (UNITY_PROJ_COORD).
                    fixed4 tint = tex2D(_MainTex, i.uv);//samples main texture at current uv coords and stores the result in the tint var as a fixed4 color val.
                    col *= tint;//multiply grabbed color by the tint color to apply any color modulation to the main texture
                    return col;//return final color for the current fragment and pixel
                }
                ENDCG
            }
        }
}
