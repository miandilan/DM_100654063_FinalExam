Shader "Custom/HologramScript"
{
    Properties
    {
        _RimColor("Rim Color", Color) = (0,0.5,0.5,0)//the properties are the vital ones for rim lighting
        _RimPower("Rim Power", Range(0,2.0)) = 3.0
    }
        SubShader
    {
        Tags{"Queue" = "Transparent"}//the transparent object is queued after the geometry one when the program runs 

        Pass
        {
            ZWrite On//enables z buffer effect
            ColorMask 0//gives shader color channel
        }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade//ensures this surface shader compiles with a dominant transparent effect
        struct Input
        {
            float3 viewDir;//outputs our view direction (POV)
        };

        float4 _RimColor;
        float _RimPower;

        void surf(Input IN, inout SurfaceOutput o)//outputs the inverse rim lighting effect with the nature of the rim lighting along 
        {                                         //with the final transparency
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));//uses the normalized view direction dot product with the surface normal
            o.Emission = _RimColor.rgb * rim * pow(rim, _RimPower);//saturate keeps range between 0-1 rather than -1 to 1
            o.Alpha = pow(rim, _RimPower);//the power's needed to make a hard gradient
        }
        ENDCG
    }
        FallBack "Diffuse"
}
