using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spinner : MonoBehaviour
{
    public GameObject myTarget;//the target light
    public float rotateSpeed;//how fast the ship moves

    // Update is called once per frame
    void Update()
    {
        transform.RotateAround(myTarget.transform.position, new Vector3(0, 1, 0), rotateSpeed * Time.deltaTime);//This rotates the object
    }
}
