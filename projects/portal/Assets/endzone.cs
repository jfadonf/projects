using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using System.Collections;

public class endzone : MonoBehaviour {

    public static int isReachTheEnd;

    void Start() {
        isReachTheEnd = 5;
    }


    private void OnTriggerEnter(Collider other) {
        isReachTheEnd = 3;
	}

}




