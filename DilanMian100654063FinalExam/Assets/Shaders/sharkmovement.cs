using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sharkmovement : MonoBehaviour
{
    public float speed = 5f;
    public GameObject plane;

    private Vector3 planeNorm;

    void Start()
    {
        //plane normal
        planeNorm = plane.transform.up;
    }

    void Update()
    {
        float horizontalInput = Input.GetAxis("Horizontal");
        float verticalInput = Input.GetAxis("Vertical");

        Vector3 movementDirection = new Vector3(horizontalInput, 0f, verticalInput);

        //if the move buttons are pushed (wasd or the arrow keys), move the player
        if (movementDirection != Vector3.zero)
        {
            //clamp the movement direction to the floor
            movementDirection = Vector3.ProjectOnPlane(movementDirection, planeNorm).normalized;

            //move the player
            transform.position += movementDirection * speed * Time.deltaTime;
        }
    }
}

