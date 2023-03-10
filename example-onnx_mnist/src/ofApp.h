#pragma once

#include "ofMain.h"
#include "ofxOnnxRuntime.h"

class ofApp : public ofBaseApp{

    ofxOnnxRuntime::BaseHandler mnist2;
    vector<float> mnist_result;

    ofFbo fbo_render;
    ofFbo fbo_classification;
    ofFloatPixels pix;
    bool prev_pressed = false;
    glm::vec2 prev_pt;

    public:
        void setup();
        void update();
        void draw();
        void keyPressed(int key);

        void keyReleased(int key) {}
        void mouseMoved(int x, int y) {}
        void mouseDragged(int x, int y, int button) {}

        void mousePressed(int x, int y, int button) {}

        void mouseReleased(int x, int y, int button) {}
        void windowResized(int w, int h) {}
        void dragEvent(ofDragInfo dragInfo) {}
        void gotMessage(ofMessage msg) {}
        
};
