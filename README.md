Este script é extremamente útil para efetuar upgrade em maquinas virtuais, pois as vezes precisamos fazer algumas modificações na maquina virtual enquanto ela está desligada e como nem sempre são apenas uma ou duas VMs, o tempo necessário para realizar estas tarefas pode ser grande (e chato). O script que escrevi consegue ler as máquinas virtuais que você escolher (pode buscar no datacenter, cluster, resource pool ou folder), verifica se todas as máquinas virtuais estão desligadas, mostra quais features do script serão aplicadas (baseado na sua configuração) e por fim lhe questiona se deseja continuar o upgrade, basta aceitar para que as modificações nas máquinas virtuais sejam iniciadas.

 - **Ações que o script executa**
	 - **Seleciona as máquinas virtuais do vCenter Server de 4 formas diferentes**
		 - Datacenter
		 - Cluster
		 - Resource Pool
		 - Folder
	 - **Efetua diversas verificações**
		 - Se as VMs estão ligadas
		 - Se as VMs já possuem o virtual hardware version em questão
		 - Se as VMs já estão com o vCPU ou Memory hotadd habilitados
	 - **Upgrade**
		 - O virtual hardware version é atualizado
		 - Remove o Floppy Drive
		 - Habilita o vCPU hotadd
		 - Habilita o Memory hotadd
	 - **Compatibilidade**
		 - vSphere (ESXi e vCenter)
		 - Testado nas versões 5.1, 5.5, 6.0 e 6.5
		 - PowerCLI
		 - Recomendo a versão 6 ou superior
	 - **Pré-requisitos**
		 - vCenter Server (Windows ou Appliance) versão 5 ou superior
		 - Garantir que o vCenter esteja acessível pela rede
		 - VMware vSphere PowerCLI versão 6 ou superior

[Mais informações](http://solutions4crowds.com.br/script-fast-upgrade-vm/)
