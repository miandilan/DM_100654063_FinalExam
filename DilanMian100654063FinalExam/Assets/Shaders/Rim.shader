Shader "Custom/Rim"
{
    Properties
    {
        _RimColor("Rim Color", Color) = (0,0.5,0.5,0)//Define each property of the rim effect with their default values.
        _RimPower("Rim Power", Range(0,2.0)) = 3.0
    }
        SubShader
    {
        Tags{"Queue" = "Transparent"}

        Pass
        {
            ZWrite On//enables depth buffer effect
            ColorMask 0//defines the shader's color channels
        }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade//This specifies we're using a non-reflective transparent type of shader.
        struct Input
        {
            float3 viewDir;//Our view direction
        };

        float4 _RimColor;//Our properties transferred here as variables to be applied to the output functions.
        float _RimPower;

        void surf(Input IN, inout SurfaceOutput o)
        {
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));//Calculates the rim value with dot product of normalized viewdirection and surface normal.
            o.Emission = _RimColor.rgb * rim * pow(rim, _RimPower);//multiple rim value and raise result the exponent of the rim's power.
            o.Alpha = pow(rim, _RimPower);//increase rim value with rim power exponent
        }
        ENDCG
    }
        FallBack "Diffuse"
}
