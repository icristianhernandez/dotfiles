{
  guardRole,
  ...
}:

let
  inputPreset = builtins.fromJSON ''
    {
        "input": {
            "blocklist": [],
            "compressor#0": {
                "attack": 20.0,
                "boost-amount": 6.0,
                "boost-threshold": -72.0,
                "bypass": false,
                "dry": -80.01,
                "hpf-frequency": 10.0,
                "hpf-mode": "Off",
                "input-gain": 0.0,
                "input-to-link": 0.0,
                "input-to-sidechain": 0.0,
                "knee": 0.0,
                "link-to-input": 0.0,
                "link-to-sidechain": 0.0,
                "lpf-frequency": 20000.0,
                "lpf-mode": "Off",
                "makeup": 9.0,
                "mode": "Downward",
                "output-gain": 0.0,
                "ratio": 4.0,
                "release": 100.0,
                "release-threshold": -80.01,
                "sidechain": {
                    "lookahead": 0.0,
                    "mode": "Peak",
                    "preamp": 0.0,
                    "reactivity": 10.0,
                    "source": "Middle",
                    "stereo-split-source": "Left/Right",
                    "type": "Feed-forward"
                },
                "sidechain-to-input": 0.0,
                "sidechain-to-link": 0.0,
                "stereo-split": false,
                "threshold": -24.0,
                "wet": 0.0
            },
            "echo_canceller#0": {
                "bypass": false,
                "echo-canceller": {
                    "automatic-gain-control": true,
                    "enable": true,
                    "enforce-high-pass": true,
                    "mobile-mode": false
                },
                "high-pass": {
                    "enable": true,
                    "full-band": true
                },
                "input-gain": 0.0,
                "noise-suppression": {
                    "enable": true,
                    "level": "Moderate"
                },
                "output-gain": 0.0
            },
            "equalizer#0": {
                "balance": 0.0,
                "bypass": false,
                "input-gain": 0.0,
                "left": {
                    "band0": {
                        "frequency": 120.0,
                        "gain": -3.0,
                        "mode": "RLC (BT)",
                        "mute": false,
                        "q": 0.7,
                        "slope": "x1",
                        "solo": false,
                        "type": "Hi-pass",
                        "width": 4.0
                    },
                    "band1": {
                        "frequency": 400.0,
                        "gain": -3.0,
                        "mode": "RLC (BT)",
                        "mute": false,
                        "q": 1.0,
                        "slope": "x1",
                        "solo": false,
                        "type": "Bell",
                        "width": 4.0
                    },
                    "band2": {
                        "frequency": 2500.0,
                        "gain": 3.0,
                        "mode": "RLC (BT)",
                        "mute": false,
                        "q": 1.2,
                        "slope": "x1",
                        "solo": false,
                        "type": "Bell",
                        "width": 4.0
                    },
                    "band3": {
                        "frequency": 8000.0,
                        "gain": 2.0,
                        "mode": "RLC (BT)",
                        "mute": false,
                        "q": 0.7,
                        "slope": "x1",
                        "solo": false,
                        "type": "Hi-shelf",
                        "width": 4.0
                    }
                },
                "mode": "IIR",
                "num-bands": 4,
                "output-gain": 0.0,
                "pitch-left": 0.0,
                "pitch-right": 0.0,
                "right": {
                    "band0": {
                        "frequency": 120.0,
                        "gain": -3.0,
                        "mode": "RLC (BT)",
                        "mute": false,
                        "q": 0.7,
                        "slope": "x1",
                        "solo": false,
                        "type": "Hi-pass",
                        "width": 4.0
                    },
                    "band1": {
                        "frequency": 400.0,
                        "gain": -3.0,
                        "mode": "RLC (BT)",
                        "mute": false,
                        "q": 1.0,
                        "slope": "x1",
                        "solo": false,
                        "type": "Bell",
                        "width": 4.0
                    },
                    "band2": {
                        "frequency": 2500.0,
                        "gain": 3.0,
                        "mode": "RLC (BT)",
                        "mute": false,
                        "q": 1.2,
                        "slope": "x1",
                        "solo": false,
                        "type": "Bell",
                        "width": 4.0
                    },
                    "band3": {
                        "frequency": 8000.0,
                        "gain": 2.0,
                        "mode": "RLC (BT)",
                        "mute": false,
                        "q": 0.7,
                        "slope": "x1",
                        "solo": false,
                        "type": "Hi-shelf",
                        "width": 4.0
                    }
                },
                "split-channels": false
            },
            "gate#0": {
                "attack": 5.0,
                "bypass": false,
                "curve-threshold": -48.0,
                "curve-zone": -6.0,
                "dry": -80.01,
                "hpf-frequency": 10.0,
                "hpf-mode": "Off",
                "hysteresis": true,
                "hysteresis-threshold": 0.0,
                "hysteresis-zone": -8.0,
                "input-gain": 0.0,
                "input-to-link": 0.0,
                "input-to-sidechain": 0.0,
                "link-to-input": 0.0,
                "link-to-sidechain": 0.0,
                "lpf-frequency": 20000.0,
                "lpf-mode": "Off",
                "makeup": 0.0,
                "output-gain": 0.0,
                "reduction": -12.0,
                "release": 200.0,
                "sidechain": {
                    "lookahead": 0.0,
                    "mode": "Peak",
                    "preamp": 0.0,
                    "reactivity": 10.0,
                    "source": "Middle",
                    "stereo-split-source": "Left/Right",
                    "type": "Internal"
                },
                "sidechain-to-input": 0.0,
                "sidechain-to-link": 0.0,
                "stereo-split": false,
                "wet": 0.0
            },
            "plugins_order": [
                "echo_canceller#0",
                "rnnoise#0",
                "gate#0",
                "equalizer#0",
                "compressor#0"
            ],
            "rnnoise#0": {
                "bypass": false,
                "enable-vad": true,
                "input-gain": 0.0,
                "model-name": "\"\"",
                "output-gain": 0.0,
                "release": 20.0,
                "use-standard-model": true,
                "vad-thres": 50.0,
                "wet": 0.0
            }
        }
    }
  '';

  outputPreset = builtins.fromJSON ''
    {
        "output": {
            "bass_enhancer#0": {
                "amount": 4.0,
                "blend": 0.0,
                "bypass": false,
                "floor": 20.0,
                "floor-active": false,
                "harmonics": 7.0,
                "input-gain": 0.0,
                "output-gain": 0.0,
                "scope": 120.0
            },
            "blocklist": [],
            "equalizer#0": {
                "balance": 0.0,
                "bypass": false,
                "input-gain": 0.0,
                "left": {
                    "band0": {
                        "frequency": 60.0,
                        "gain": 0.0,
                        "mode": "RLC (BT)",
                        "mute": false,
                        "q": 1.0,
                        "slope": "x1",
                        "solo": false,
                        "type": "Hi-pass",
                        "width": 4.0
                    },
                    "band1": {
                        "frequency": 110.0,
                        "gain": 2.5,
                        "mode": "RLC (BT)",
                        "mute": false,
                        "q": 1.4,
                        "slope": "x1",
                        "solo": false,
                        "type": "Bell",
                        "width": 4.0
                    },
                    "band2": {
                        "frequency": 350.0,
                        "gain": -3.0,
                        "mode": "RLC (BT)",
                        "mute": false,
                        "q": 1.0,
                        "slope": "x1",
                        "solo": false,
                        "type": "Bell",
                        "width": 4.0
                    },
                    "band3": {
                        "frequency": 2000.0,
                        "gain": 1.5,
                        "mode": "RLC (BT)",
                        "mute": false,
                        "q": 1.0,
                        "slope": "x1",
                        "solo": false,
                        "type": "Bell",
                        "width": 4.0
                    },
                    "band4": {
                        "frequency": 10000.0,
                        "gain": 3.0,
                        "mode": "RLC (BT)",
                        "mute": false,
                        "q": 0.7,
                        "slope": "x1",
                        "solo": false,
                        "type": "Hi-shelf",
                        "width": 4.0
                    }
                },
                "mode": "IIR",
                "num-bands": 5,
                "output-gain": 0.0,
                "pitch-left": 0.0,
                "pitch-right": 0.0,
                "right": {
                    "band0": {
                        "frequency": 60.0,
                        "gain": 0.0,
                        "mode": "RLC (BT)",
                        "mute": false,
                        "q": 1.0,
                        "slope": "x1",
                        "solo": false,
                        "type": "Hi-pass",
                        "width": 4.0
                    },
                    "band1": {
                        "frequency": 110.0,
                        "gain": 2.5,
                        "mode": "RLC (BT)",
                        "mute": false,
                        "q": 1.4,
                        "slope": "x1",
                        "solo": false,
                        "type": "Bell",
                        "width": 4.0
                    },
                    "band2": {
                        "frequency": 350.0,
                        "gain": -3.0,
                        "mode": "RLC (BT)",
                        "mute": false,
                        "q": 1.0,
                        "slope": "x1",
                        "solo": false,
                        "type": "Bell",
                        "width": 4.0
                    },
                    "band3": {
                        "frequency": 2000.0,
                        "gain": 1.5,
                        "mode": "RLC (BT)",
                        "mute": false,
                        "q": 1.0,
                        "slope": "x1",
                        "solo": false,
                        "type": "Bell",
                        "width": 4.0
                    },
                    "band4": {
                        "frequency": 10000.0,
                        "gain": 3.0,
                        "mode": "RLC (BT)",
                        "mute": false,
                        "q": 0.7,
                        "slope": "x1",
                        "solo": false,
                        "type": "Hi-shelf",
                        "width": 4.0
                    }
                },
                "split-channels": false
            },
            "limiter#0": {
                "alr": false,
                "alr-attack": 5.0,
                "alr-knee": 0.0,
                "alr-knee-smooth": -5.0,
                "alr-release": 50.0,
                "attack": 5.0,
                "bypass": false,
                "dithering": "None",
                "gain-boost": true,
                "input-gain": 0.0,
                "input-to-link": 0.0,
                "input-to-sidechain": 0.0,
                "link-to-input": 0.0,
                "link-to-sidechain": 0.0,
                "lookahead": 5.0,
                "mode": "Herm Thin",
                "output-gain": 0.0,
                "oversampling": "None",
                "release": 20.0,
                "sidechain-preamp": 0.0,
                "sidechain-to-input": 0.0,
                "sidechain-to-link": 0.0,
                "sidechain-type": "Internal",
                "stereo-link": 100.0,
                "threshold": -0.5
            },
            "plugins_order": [
                "bass_enhancer#0",
                "stereo_tools#0",
                "equalizer#0",
                "limiter#0"
            ],
            "stereo_tools#0": {
                "balance-in": 0.0,
                "balance-out": 0.0,
                "bypass": false,
                "delay": 0.0,
                "dry": -100.0,
                "input-gain": 0.0,
                "middle-level": 0.0,
                "middle-panorama": 0.0,
                "mode": "LR > LR (Stereo Default)",
                "mutel": false,
                "muter": false,
                "output-gain": 0.0,
                "phasel": false,
                "phaser": false,
                "sc-level": 1.0,
                "side-balance": 0.0,
                "side-level": 1.6,
                "softclip": true,
                "stereo-base": 0.0,
                "stereo-phase": 0.0,
                "wet": 0.0
            }
        }
    }
  '';

in
guardRole "thinkpadE14" {
  services.easyeffects = {
    enable = true;

    extraPresets = {
      "Thinkpad E14 Input Enchancement" = inputPreset;
      "Thinkpad E14 Output Enchancement" = outputPreset;
    };
  };
}
