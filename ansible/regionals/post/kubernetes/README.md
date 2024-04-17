```mermaid
---
title: Ansible Playbook Grapher
---
%%{ init: { "flowchart": { "curve": "bumpX" } } }%%
flowchart LR
	%% Start of the playbook 'playbook.yaml'
	playbook_6c169189("playbook.yaml")
		%% Start of the play 'Play: K8s set hostname (44)'
		play_511f046d["Play: K8s set hostname (44)"]
		style play_511f046d fill:#a38d29,color:#ffffff
		playbook_6c169189 --> |"1"| play_511f046d
		linkStyle 0 stroke:#a38d29,color:#a38d29
			%% Start of the role '../../roles/hostsetup'
			play_511f046d --> |"1"| role_23bdb419
			linkStyle 1 stroke:#a38d29,color:#a38d29
			role_23bdb419("[role] ../../roles/hostsetup")
			style role_23bdb419 fill:#a38d29,color:#ffffff,stroke:#a38d29
			%% End of the role '../../roles/hostsetup'
			task_ee0358b9["[task]  Update Ubuntu password"]
			style task_ee0358b9 stroke:#a38d29,fill:#ffffff
			play_511f046d --> |"2"| task_ee0358b9
			linkStyle 2 stroke:#a38d29,color:#a38d29
		%% End of the play 'Play: K8s set hostname (44)'
		%% Start of the play 'Play: K8s base (11)'
		play_ea9ec137["Play: K8s base (11)"]
		style play_ea9ec137 fill:#2549a7,color:#ffffff
		playbook_6c169189 --> |"2"| play_ea9ec137
		linkStyle 3 stroke:#2549a7,color:#2549a7
			task_e8d64b24["[task]  Initialize the cluster"]
			style task_e8d64b24 stroke:#2549a7,fill:#ffffff
			play_ea9ec137 --> |"1"| task_e8d64b24
			linkStyle 4 stroke:#2549a7,color:#2549a7
			task_8f24505e["[task]  Copy admin.conf to user's kube config"]
			style task_8f24505e stroke:#2549a7,fill:#ffffff
			play_ea9ec137 --> |"2"| task_8f24505e
			linkStyle 5 stroke:#2549a7,color:#2549a7
			task_eebda270["[task]  Wait for kube-system pods become ready"]
			style task_eebda270 stroke:#2549a7,fill:#ffffff
			play_ea9ec137 --> |"3"| task_eebda270
			linkStyle 6 stroke:#2549a7,color:#2549a7
			task_4faf0baa["[task]  Install calico networking"]
			style task_4faf0baa stroke:#2549a7,fill:#ffffff
			play_ea9ec137 --> |"4"| task_4faf0baa
			linkStyle 7 stroke:#2549a7,color:#2549a7
			task_4273ea3c["[task]  Wait for calico pods to start"]
			style task_4273ea3c stroke:#2549a7,fill:#ffffff
			play_ea9ec137 --> |"5"| task_4273ea3c
			linkStyle 8 stroke:#2549a7,color:#2549a7
			task_6fdc6d27["[task]  Wait for calico pods become ready"]
			style task_6fdc6d27 stroke:#2549a7,fill:#ffffff
			play_ea9ec137 --> |"6"| task_6fdc6d27
			linkStyle 9 stroke:#2549a7,color:#2549a7
			task_4d82feb2["[task]  Remove taint from nodes"]
			style task_4d82feb2 stroke:#2549a7,fill:#ffffff
			play_ea9ec137 --> |"7"| task_4d82feb2
			linkStyle 10 stroke:#2549a7,color:#2549a7
			task_dc240f5b["[task]  Create kube directory for black team user"]
			style task_dc240f5b stroke:#2549a7,fill:#ffffff
			play_ea9ec137 --> |"8"| task_dc240f5b
			linkStyle 11 stroke:#2549a7,color:#2549a7
			task_91443588["[task]  Create black team user"]
			style task_91443588 stroke:#2549a7,fill:#ffffff
			play_ea9ec137 --> |"9"| task_91443588
			linkStyle 12 stroke:#2549a7,color:#2549a7
			task_ea296460["[task]  Change file permissions on kubeconfig"]
			style task_ea296460 stroke:#2549a7,fill:#ffffff
			play_ea9ec137 --> |"10"| task_ea296460
			linkStyle 13 stroke:#2549a7,color:#2549a7
			task_e7764fec["[task]  Create cluster role for black team"]
			style task_e7764fec stroke:#2549a7,fill:#ffffff
			play_ea9ec137 --> |"11"| task_e7764fec
			linkStyle 14 stroke:#2549a7,color:#2549a7
			task_28ef1067["[task]  Create cluster role binding for black team"]
			style task_28ef1067 stroke:#2549a7,fill:#ffffff
			play_ea9ec137 --> |"12"| task_28ef1067
			linkStyle 15 stroke:#2549a7,color:#2549a7
			task_5e5fe46a["[task]  Get join command"]
			style task_5e5fe46a stroke:#2549a7,fill:#ffffff
			play_ea9ec137 --> |"13"| task_5e5fe46a
			linkStyle 16 stroke:#2549a7,color:#2549a7
			task_189a7356["[task]  Set join command"]
			style task_189a7356 stroke:#2549a7,fill:#ffffff
			play_ea9ec137 --> |"14"| task_189a7356
			linkStyle 17 stroke:#2549a7,color:#2549a7
		%% End of the play 'Play: K8s base (11)'
		%% Start of the play 'Play: Join docker worker node (22)'
		play_354b8ec8["Play: Join docker worker node (22)"]
		style play_354b8ec8 fill:#a5a824,color:#ffffff
		playbook_6c169189 --> |"3"| play_354b8ec8
		linkStyle 18 stroke:#a5a824,color:#a5a824
			task_b51e863e["[task]  TCP port 6443 on master is reachable from worker"]
			style task_b51e863e stroke:#a5a824,fill:#ffffff
			play_354b8ec8 --> |"1"| task_b51e863e
			linkStyle 19 stroke:#a5a824,color:#a5a824
			task_71abd5db["[task]  Join cluster"]
			style task_71abd5db stroke:#a5a824,fill:#ffffff
			play_354b8ec8 --> |"2"| task_71abd5db
			linkStyle 20 stroke:#a5a824,color:#a5a824
		%% End of the play 'Play: Join docker worker node (22)'
		%% Start of the play 'Play: Join containerd worker node (11)'
		play_21b0e56d["Play: Join containerd worker node (11)"]
		style play_21b0e56d fill:#4fc606,color:#ffffff
		playbook_6c169189 --> |"4"| play_21b0e56d
		linkStyle 21 stroke:#4fc606,color:#4fc606
			task_21ec04e3["[task]  TCP port 6443 on master is reachable from worker"]
			style task_21ec04e3 stroke:#4fc606,fill:#ffffff
			play_21b0e56d --> |"1"| task_21ec04e3
			linkStyle 22 stroke:#4fc606,color:#4fc606
			task_2969de14["[task]  Join cluster"]
			style task_2969de14 stroke:#4fc606,fill:#ffffff
			play_21b0e56d --> |"2"| task_2969de14
			linkStyle 23 stroke:#4fc606,color:#4fc606
		%% End of the play 'Play: Join containerd worker node (11)'
		%% Start of the play 'Play: Kubernetes deployment (11)'
		play_54735a91["Play: Kubernetes deployment (11)"]
		style play_54735a91 fill:#bc1055,color:#ffffff
		playbook_6c169189 --> |"5"| play_54735a91
		linkStyle 24 stroke:#bc1055,color:#bc1055
			task_61f07ee3["[task]  Create ingress namespace"]
			style task_61f07ee3 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"1"| task_61f07ee3
			linkStyle 25 stroke:#bc1055,color:#bc1055
			task_d47a9f83["[task]  Deploy haproxy-ingress"]
			style task_d47a9f83 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"2"| task_d47a9f83
			linkStyle 26 stroke:#bc1055,color:#bc1055
			task_cb20f871["[task]  Create a argocd namespace"]
			style task_cb20f871 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"3"| task_cb20f871
			linkStyle 27 stroke:#bc1055,color:#bc1055
			task_4c8d0e2b["[task]  Deploy ArgoCD"]
			style task_4c8d0e2b stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"4"| task_4c8d0e2b
			linkStyle 28 stroke:#bc1055,color:#bc1055
			task_1d063ab2["[task]  Create argocd web tls secret"]
			style task_1d063ab2 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"5"| task_1d063ab2
			linkStyle 29 stroke:#bc1055,color:#bc1055
			task_651f7057["[task]  Create argocd ingress"]
			style task_651f7057 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"6"| task_651f7057
			linkStyle 30 stroke:#bc1055,color:#bc1055
			task_8b421dc5["[task]  Wait for argocd init secret to be generated"]
			style task_8b421dc5 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"7"| task_8b421dc5
			linkStyle 31 stroke:#bc1055,color:#bc1055
			task_6e217bff["[task]  Retrieve password from Argo CD secret"]
			style task_6e217bff stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"8"| task_6e217bff
			linkStyle 32 stroke:#bc1055,color:#bc1055
			task_4ce4ceef["[task]  Display Argo CD secret password"]
			style task_4ce4ceef stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"9"| task_4ce4ceef
			linkStyle 33 stroke:#bc1055,color:#bc1055
			task_813e7ff2["[task]  Login to Argo CD"]
			style task_813e7ff2 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"10"| task_813e7ff2
			linkStyle 34 stroke:#bc1055,color:#bc1055
			task_776a1c4a["[task]  Update Argo CD admin password"]
			style task_776a1c4a stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"11"| task_776a1c4a
			linkStyle 35 stroke:#bc1055,color:#bc1055
			task_cbfd22f7["[task]  Create a Longhorn namespace"]
			style task_cbfd22f7 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"12"| task_cbfd22f7
			linkStyle 36 stroke:#bc1055,color:#bc1055
			task_63a730dc["[task]  Create Longhorn ArgoCD application"]
			style task_63a730dc stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"13"| task_63a730dc
			linkStyle 37 stroke:#bc1055,color:#bc1055
			task_6c1cf189["[task]  Create a Falco namespace"]
			style task_6c1cf189 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"14"| task_6c1cf189
			linkStyle 38 stroke:#bc1055,color:#bc1055
			task_a3bd5947["[task]  Create Falco ArgoCD application"]
			style task_a3bd5947 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"15"| task_a3bd5947
			linkStyle 39 stroke:#bc1055,color:#bc1055
			task_9f6db4d1["[task]  Create postgresql (database) namespace"]
			style task_9f6db4d1 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"16"| task_9f6db4d1
			linkStyle 40 stroke:#bc1055,color:#bc1055
			task_cd8ad00a["[task]  Create PostgreSQL HA ArgoCD application"]
			style task_cd8ad00a stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"17"| task_cd8ad00a
			linkStyle 41 stroke:#bc1055,color:#bc1055
			task_8603fd4a["[task]  Create code server service account"]
			style task_8603fd4a stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"18"| task_8603fd4a
			linkStyle 42 stroke:#bc1055,color:#bc1055
			task_f1c48221["[task]  Create code cluster role to list pods"]
			style task_f1c48221 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"19"| task_f1c48221
			linkStyle 43 stroke:#bc1055,color:#bc1055
			task_2bee85f7["[task]  Create code service account policy binding"]
			style task_2bee85f7 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"20"| task_2bee85f7
			linkStyle 44 stroke:#bc1055,color:#bc1055
			task_30caf4a4["[task]  Create code server deployment"]
			style task_30caf4a4 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"21"| task_30caf4a4
			linkStyle 45 stroke:#bc1055,color:#bc1055
			task_fee446bc["[task]  Create code server service"]
			style task_fee446bc stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"22"| task_fee446bc
			linkStyle 46 stroke:#bc1055,color:#bc1055
			task_0afe8d72["[task]  Create code tls secret"]
			style task_0afe8d72 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"23"| task_0afe8d72
			linkStyle 47 stroke:#bc1055,color:#bc1055
			task_daba3ac2["[task]  Create code server ingress"]
			style task_daba3ac2 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"24"| task_daba3ac2
			linkStyle 48 stroke:#bc1055,color:#bc1055
			task_0cd20ba2["[task]  Create a Kubernetes Dashboard namespace"]
			style task_0cd20ba2 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"25"| task_0cd20ba2
			linkStyle 49 stroke:#bc1055,color:#bc1055
			task_fb75ca25["[task]  Create Kubernetes Dashboard ArgoCD project"]
			style task_fb75ca25 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"26"| task_fb75ca25
			linkStyle 50 stroke:#bc1055,color:#bc1055
			task_bf38e508["[task]  Create Kubernetes Dashboard ArgoCD application"]
			style task_bf38e508 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"27"| task_bf38e508
			linkStyle 51 stroke:#bc1055,color:#bc1055
			task_d8dbcaf9["[task]  Create Nextcloud namespace"]
			style task_d8dbcaf9 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"28"| task_d8dbcaf9
			linkStyle 52 stroke:#bc1055,color:#bc1055
			task_b6632c9c["[task]  Create Nextcloud database secret"]
			style task_b6632c9c stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"29"| task_b6632c9c
			linkStyle 53 stroke:#bc1055,color:#bc1055
			task_9b8a44f8["[task]  Create nextcloud tls secret"]
			style task_9b8a44f8 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"30"| task_9b8a44f8
			linkStyle 54 stroke:#bc1055,color:#bc1055
			task_eb18319b["[task]  Create Nextcloud PersistentVolumeClaim"]
			style task_eb18319b stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"31"| task_eb18319b
			linkStyle 55 stroke:#bc1055,color:#bc1055
			task_141a57e3["[task]  Wait for nextcloud pvc to generate"]
			style task_141a57e3 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"32"| task_141a57e3
			linkStyle 56 stroke:#bc1055,color:#bc1055
			task_1d2d24b0["[task]  Create Nextcloud ArgoCD application"]
			style task_1d2d24b0 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"33"| task_1d2d24b0
			linkStyle 57 stroke:#bc1055,color:#bc1055
			task_c788d3b8["[task]  Fortunes cronjob"]
			style task_c788d3b8 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"34"| task_c788d3b8
			linkStyle 58 stroke:#bc1055,color:#bc1055
			task_4e1f085c["[task]  Create a prod namespace"]
			style task_4e1f085c stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"35"| task_4e1f085c
			linkStyle 59 stroke:#bc1055,color:#bc1055
			task_656b5175["[task]  Create salmon service account"]
			style task_656b5175 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"36"| task_656b5175
			linkStyle 60 stroke:#bc1055,color:#bc1055
			task_9247cc67["[task]  Create GitLab infrastructure SSH key secret"]
			style task_9247cc67 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"37"| task_9247cc67
			linkStyle 61 stroke:#bc1055,color:#bc1055
			task_666a84b6["[task]  Create GitLab runner SSH key secret"]
			style task_666a84b6 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"38"| task_666a84b6
			linkStyle 62 stroke:#bc1055,color:#bc1055
			task_749bd037["[task]  Create GitLab fun SSH key secret"]
			style task_749bd037 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"39"| task_749bd037
			linkStyle 63 stroke:#bc1055,color:#bc1055
			task_001a84b0["[task]  Create GitLab shop SSH key secret"]
			style task_001a84b0 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"40"| task_001a84b0
			linkStyle 64 stroke:#bc1055,color:#bc1055
			task_5f3a4fb5["[task]  Create GitLab registry auth secret"]
			style task_5f3a4fb5 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"41"| task_5f3a4fb5
			linkStyle 65 stroke:#bc1055,color:#bc1055
			task_ec906562["[task]  Create GitLab infrastructure application"]
			style task_ec906562 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"42"| task_ec906562
			linkStyle 66 stroke:#bc1055,color:#bc1055
			task_21692cd4["[task]  Create GitLab runner application"]
			style task_21692cd4 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"43"| task_21692cd4
			linkStyle 67 stroke:#bc1055,color:#bc1055
			task_f21f32da["[task]  Create a prod namespace"]
			style task_f21f32da stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"44"| task_f21f32da
			linkStyle 68 stroke:#bc1055,color:#bc1055
			task_9f8d6f8e["[task]  Create tethys service account"]
			style task_9f8d6f8e stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"45"| task_9f8d6f8e
			linkStyle 69 stroke:#bc1055,color:#bc1055
			task_05bebbdd["[task]  Create tethys role"]
			style task_05bebbdd stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"46"| task_05bebbdd
			linkStyle 70 stroke:#bc1055,color:#bc1055
			task_e846f324["[task]  Create tethys service account policy binding"]
			style task_e846f324 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"47"| task_e846f324
			linkStyle 71 stroke:#bc1055,color:#bc1055
			task_8b306fb7["[task]  Create tethys service"]
			style task_8b306fb7 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"48"| task_8b306fb7
			linkStyle 72 stroke:#bc1055,color:#bc1055
			task_2ad0d7f5["[task]  Create tethys ingress"]
			style task_2ad0d7f5 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"49"| task_2ad0d7f5
			linkStyle 73 stroke:#bc1055,color:#bc1055
			task_fa30ca18["[task]  Create dammon configmap"]
			style task_fa30ca18 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"50"| task_fa30ca18
			linkStyle 74 stroke:#bc1055,color:#bc1055
			task_2462fb2c["[task]  Create dammon deployment"]
			style task_2462fb2c stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"51"| task_2462fb2c
			linkStyle 75 stroke:#bc1055,color:#bc1055
			task_2ad58585["[task]  Create dammon service"]
			style task_2ad58585 stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"52"| task_2ad58585
			linkStyle 76 stroke:#bc1055,color:#bc1055
			task_e40e070f["[task]  Create dammon ingress"]
			style task_e40e070f stroke:#bc1055,fill:#ffffff
			play_54735a91 --> |"53"| task_e40e070f
			linkStyle 77 stroke:#bc1055,color:#bc1055
		%% End of the play 'Play: Kubernetes deployment (11)'
		%% Start of the play 'Play: K8s cleanup (44)'
		play_5d661a40["Play: K8s cleanup (44)"]
		style play_5d661a40 fill:#653a92,color:#ffffff
		playbook_6c169189 --> |"6"| play_5d661a40
		linkStyle 78 stroke:#653a92,color:#653a92
			task_f2464599["[task]  Remove kubeadm config file"]
			style task_f2464599 stroke:#653a92,fill:#ffffff
			play_5d661a40 --> |"1"| task_f2464599
			linkStyle 79 stroke:#653a92,color:#653a92
		%% End of the play 'Play: K8s cleanup (44)'
	%% End of the playbook 'playbook.yaml'


```