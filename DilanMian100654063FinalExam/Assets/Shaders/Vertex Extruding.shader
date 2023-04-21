Shader "Custom/Vertex Extruding"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Amount("Extrude", Range(0, 0.5)) = 0
    }
        SubShader
        {
            CGPROGRAM
            #pragma surface surf Lambert vertex:vert//Tells Unity this shader is using the vertex shader to create a lambert shader

            struct Input
            {
                float2 uv_MainTex;//Use the uv coordinates of your texture image to manipulated in the shader function
            };

            struct appdata
            {
                float4 vertex: POSITION;//These are the positions, normals, and uv coordinated for each vertex in the mesh
                float3 normal: NORMAL;
                float4 texcoord: TEXCOORD0;

            };

            float _Amount;//Extrude range
            void vert(inout appdata v)
            {
                v.vertex.xyz += v.normal * _Amount;//modifies the appdata information (its vertex position) by adding the normal vector multiplied by
            }                                      //the extrude amount 

            sampler2D _Maintex;
            void surf(Input IN, inout SurfaceOutput o)//Takes the uv coordinates from the input
            {
                o.Albedo = tex2D(_Maintex, IN.uv_MainTex).rgb;//surface color is set to rgb values of the texture for each uv coordinate
            }
            ENDCG
        }
            FallBack "Diffuse"
}
