Shader "Custom/Specular"
{
    Properties
    {
        _Color("Color", Color) = (1.0,1.0,1.0)//Our default values for each necessary property.
        _SpecColor("Color", Color) = (1.0,1.0,1.0)
        _Shininess("Shininess", Float) = 10

    }

        SubShader
    {
        Pass {


        Tags {"LightMode" = "ForwardBase"}

        CGPROGRAM

        #pragma vertex vert//Indicating the shader is focused on manipulating the vertex and fragment shaders.
        #pragma fragment frag

        // user defined variables
        uniform float4 _Color;//These will be used below to calculate specular lighting.
        uniform float4 _SpecColor;
        uniform float _Shininess;

        // unity defined variables
        uniform float4 _LightColor0;

        // structs
        struct vertexInput {
            float4 vertex : POSITION;//We output our vertex position and normals for each vertex.
            float3 normal : NORMAL;
        };

        struct vertexOutput {
            float4 pos : SV_POSITION;//Here is our position in world space and normal directions for each texture coordinate.
            float4 posWorld : TEXCOORD0;
            float4 normalDir : TEXCOORD1;
        };

        //vertex function
        vertexOutput vert(vertexInput v) {
            vertexOutput o;
            o.posWorld = mul(unity_ObjectToWorld, v.vertex);//This actually puts our object into world space.
            o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject));//Defines the normal direction of the object
            o.pos = UnityObjectToClipPos(v.vertex);//the texture's position is defined
            return o;
        }

        // fragment function
        float4 frag(vertexOutput i) : COLOR
        {
            // vectors
            float3 normalDirection = i.normalDir;
            float atten = 1.0;
            // lighting
            float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
            float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection,
           lightDirection));
            // specular direction
            float3 lightReflectDirection = reflect(-lightDirection, normalDirection);
            float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0) -
           i.posWorld.xyz));
            float3 lightSeeDirection = max(0.0,dot(lightReflectDirection, viewDirection));
            float3 shininessPower = pow(lightSeeDirection, _Shininess);
            float3 specularReflection = atten * _SpecColor.rgb * shininessPower;
            float3 lightFinal = diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT;
            return float4(lightFinal * _Color.rgb, 1.0);
        }

         ENDCG
        }
    }
        FallBack "Diffuse"
}
    
 
