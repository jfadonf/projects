using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class DespawnOnHeight : MonoBehaviour
{

    void Update()
    {
        if (transform.position.y < -2)
        {
            // stop the whisper
            Destroy(GameObject.Find("WhisperSource"));

            // transfer to game over scene

            SceneManager.LoadScene("GameOver");
        }
    }
}
