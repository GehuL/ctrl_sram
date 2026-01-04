# Introduction
Projet VHDL réalisé en dernière année d'école d'ingénieur à Polytech Dijon en spécialité systèmes embarqués.
L'objectif est de créer un contrôleur de [SRAM ZBT](https://pf02.ickimg.com/datasheet/d8/56/7bd5/d8/fde7435f680ed7601ea25fa24e3f5e67.pdf) de 36bits sur 512K mots.
# Interface

<img width="923" height="659" alt="image" src="https://github.com/user-attachments/assets/2b22eb76-fbbf-4881-afcd-fc020fc5db6d" />

Write timing:
<img width="945" height="288" alt="image" src="https://github.com/user-attachments/assets/641c81ca-4e52-4c53-89d0-c6c49ddeede5" />
Read timing:
<img width="945" height="383" alt="image" src="https://github.com/user-attachments/assets/bb3c0711-3d8d-4da5-aeac-3e6894a453e8" />
Burst timing:
<img width="945" height="483" alt="image" src="https://github.com/user-attachments/assets/b93705c7-1b7d-404a-83f0-0d8118dec29d" />

# Fonctionnalités
- [x] Lecture/ecriture simple
- [x] Mode burst en lecture/ecriture
- [ ] Vérification des erreurs de parité
