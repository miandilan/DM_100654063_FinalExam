Shader "Custom/CustomLUTShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _LUT("LUT", 2D) = "white" {}
        _Contribution("Contribution", Range(0, 1)) = 1
    }
        SubShader
        {
            //No culling or depth
            Cull Off ZWrite Off ZTest Always

            Pass
            {
                CGPROGRAM
                #pragma vertex vert//using the vertex and fragment shader
                #pragma fragment frag

                #include "UnityCG.cginc"//allows us to use tools specifically for this shader

                #define COLORS 32.0

                struct appdata//input into the vertex shader
                {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct v2f//output from the vertex shader
                {
                    float2 uv : TEXCOORD0;
                    float4 vertex : SV_POSITION;
                };

                v2f vert(appdata v)//in the vertex shader, output thre clip space position of each vertex and their uv coords
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = v.uv;
                    return o;
                }

                sampler2D _MainTex;
                sampler2D _LUT;
                float4 _LUT_TexelSize;
                float _Contribution;

                fixed4 frag(v2f i) : SV_Target
                {
                    float maxColor = COLORS - 1.0;//color limit
                    fixed4 col = saturate(tex2D(_MainTex, i.uv));//amount of color being used on each uv coord of the texture image
                    float halfColX = 0.5 / _LUT_TexelSize.z;
                    float halfColY = 0.5 / _LUT_TexelSize.w;
                    float threshold = maxColor / COLORS;

                    float xOffset = halfColX + col.r * threshold / COLORS;//the offset x/y components for red and green
                    float yOffset = halfColY + col.g * threshold;
                    float cell = floor(col.b * maxColor);//the parameters of each cell 

                    float2 lutPos = float2(cell / COLORS + xOffset, yOffset);//the lut position of each color
                    float4 gradedCol = tex2D(_LUT, lutPos);//the texture image of the lut on our screen space

                    return lerp(col, gradedCol, _Contribution);//finally return the interpolation between the saturated color, the LUT colors, and contribution
                }
                ENDCG
            }
        }
}
