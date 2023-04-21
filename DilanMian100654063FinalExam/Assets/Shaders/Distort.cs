using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class Distort : MonoBehaviour
{
    const int distortionPass = 0;

    //the 3 variables below can modify the distortion in the unity inspector
    public Shader distortionAberrationShader;
    [Range(-1f, 1f)]
    public float Distortion = 0.1f;
    [Range(0f, 10f)]
    public float Scale = 1f;

    [Range(-0.01f, 0.01f)]
    public float OffsetR = 0.001f;
    [Range(-0.01f, 0.01f)]
    public float OffsetG = 0.001f;
    [Range(-0.01f, 0.01f)]
    public float OffsetB = -0.001f;
    [NonSerialized]
    Material distAbMaterial;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (distAbMaterial == null)
        {
            distAbMaterial = new Material(distortionAberrationShader);
            distAbMaterial.hideFlags = HideFlags.HideAndDontSave;
        }
        distAbMaterial.SetFloat("_Distortion", Distortion);//ensures the shader can access these values
        distAbMaterial.SetFloat("_Scale", Scale);
        distAbMaterial.SetFloat("_OffsetR", OffsetR);
        distAbMaterial.SetFloat("_OffsetG", OffsetG);
        distAbMaterial.SetFloat("_OffsetB", OffsetB);
        Graphics.Blit(source, destination, distAbMaterial, distortionPass);//blit using the pass in the shader
    }
}
