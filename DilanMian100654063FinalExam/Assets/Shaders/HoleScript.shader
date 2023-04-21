Shader "Custom/HoleScript"
{
    Properties
    {
        _MainTex("Defuse", 2D) = "white" {}//standard property fo the texture with a set color
    }
        SubShader
    {
        Tags { "Queue" = "Geometry-1" }

        ColorMask 0//defines shader color channels
        ZWrite off//enables z buffer effect
        
        Stencil {//our stencil operation that always passes and replaces the stencil buffer val at current pixel with 1
            Ref 1//the reference value
            Comp always//how the operation will be performed (always)
            Pass replace//ensures a replacement will happen if the stencil operation succeeds
        }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert


        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;//our uv coords of the texture are outputted
        };


        void surf(Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
        }
        ENDCG
    }
        FallBack "Diffuse"
}
