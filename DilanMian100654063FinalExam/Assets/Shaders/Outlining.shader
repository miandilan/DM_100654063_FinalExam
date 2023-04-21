Shader "Custom/Outlining"
{
    Properties//Our properties to be used in the subshader
    {
        _Colour("Colour", Color) = (1,1,1,1)
        _OutlineColour("Outline Colour", Color) = (1, 1, 1, 1)//The actual color of the outline
        _OutlineWidth("Outline Width", range(0, 1)) = 1//The width of the outline
        [HideInInspector]
        _MainTex("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }//Rendered with opacity

        CGPROGRAM
        #pragma surface surf Lambert//unity knows we're making a lambert shader 

        struct Input
        {
            float2 uv_MainTex;//the uv coordinates are being used in the shader function
        };

        sampler2D _MainTex;
        float4 _Colour;

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Colour;
            o.Albedo = c.rgb;//The albedo property is set to the color property values for each uv coordinate
        }
        ENDCG

        Pass
        {
            Cull Front//this ensures only the back-facing polygons are drawn for the outline
            CGPROGRAM
            #pragma vertex vert//We'll be using both the vertex and fragment shaders
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata//The vertex shader is taking these as input for each vertex of the mesh
            {
                float4 position : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f//This is being outputted by the vertex shader to get the position and color for each vertice of the outline
            {
                float4 position : SV_POSITION;
                float4 colour : COLOR;
            };

            float4 _OutlineColour;
            float _OutlineWidth;

            v2f vert(appdata i)//Here the position of the vertices is calculated based on the offset of the normal and outline width
            {
                v2f o;//v2f output data
                o.position = UnityObjectToClipPos(i.position);//output vertex position is set to clip space position of the input vertex pos
                float3 normal = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, i.normal));//transform vertex norm from object space to view space 
                                                                                       //with normalization for unit vector
                float2 offset = TransformViewToProjection(normal.xy);//transform normalized view space normal into projection space, giving a vector pointing to
                                                                     //the edges of the object
                o.position.xy += offset * o.position.z * _OutlineWidth;//add the offset vector to the x/y components of the output vertex pos, scaled by
                                                                       //the distance from the camera to the vertex and outline width
                o.colour = _OutlineColour;//output vertex color is set to the outline color property vals                          

                return o;//returns the output v2f struct with the updated vertex position and color
            }

            float4 frag(v2f i) : SV_Target
            {
                return i.colour;//This is the final color of each fragment for the outline
            }

            ENDCG
        }
    }
        FallBack "Diffuse"
}
