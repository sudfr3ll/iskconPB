import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { AudioService } from 'src/app/services/audio.service';
import { CategoriesService } from 'src/app/services/categories.service';
import { UtilityService } from 'src/app/services/utility.service';
import { getDownloadURL, getStorage, ref, uploadBytesResumable, uploadString } from "@angular/fire/storage";
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-edit-audio',
  templateUrl: './edit-audio.component.html',
  styleUrls: ['./edit-audio.component.scss']
})
export class EditAudioComponent implements OnInit {
  showLoader: boolean = false;
  audio: any;
  categories = ['L1', 'L2', 'L3'];
  audiosData: any;
  categoryOneData: any;
  categoryThreeData: any = [];
  categoryTwoData: any = [];
  categoryOneId: any;
  categoryTwoId: any;
  categoryThreeId: any;
  showProgress: any
  categoryOneAudioData: any = [];
  categoryTwoAudioData: any = [];
  categoryThreeAudioData: any = [];

  audioArr: any = [];
  audioTitle: any;
  keyword: string = '';

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    private audioService: AudioService,
    private utilityService: UtilityService,
    private categoriesService: CategoriesService,
    private snackbar: MatSnackBar,

    private dialogRef: MatDialogRef<EditAudioComponent>
  ) { this.dialogRef.disableClose = true; }

  async ngOnInit() {
    await this.audioData()
    await this.getCategoryOne()

  }

  async getCategoryOne() {
    this.categoryOneData = await this.categoriesService.getCategoryOne();
    this.categoryOneAudioData = await this.categoryOneData.filter((data: { type: any; }) => 'audios' == data.type)

    for (let i = 0; i < this.categoryOneAudioData.length; i++) {
      if (this.audio.categories.includes(this.categoryOneAudioData[i].id)) {
        this.categoryOneId = this.categoryOneAudioData[i].id;
      }
    }
    if (this.categoryOneId) {
      await this.getCategoryTwo(this.categoryOneId);
    }
  }

  async getCategoryTwo(categoryOneId: string) {
    this.categoryTwoData = await this.categoriesService.getCategoryTwoWithId(categoryOneId);
    this.categoryTwoAudioData = await this.categoryTwoData.filter((data: { type: any; }) => 'audios' == data.type)
    for (let i = 0; i < this.categoryTwoAudioData.length; i++) {
      if (this.audio.categories.includes(this.categoryTwoAudioData[i].id)) {
        this.categoryTwoId = this.categoryTwoAudioData[i].id;
      }
    }

    if (this.categoryTwoId) {
      this.getCategoryThree(this.categoryOneId, this.categoryTwoId);
    }

  }

  async getCategoryThree(categoryOneId: string, categoryTwoId: string) {
    this.categoryThreeData = await this.categoriesService.getCategoryThreeWithId(categoryOneId, categoryTwoId);
    this.categoryThreeAudioData = await this.categoryThreeData.filter((data: { type: any; }) => 'audios' == data.type)

    for (let i = 0; i < this.categoryThreeAudioData.length; i++) {
      if (this.audio.categories.includes(this.categoryThreeAudioData[i].id)) {
        this.categoryThreeId = this.categoryThreeAudioData[i].id;
      }
    }
  }


  async audioData() {
    if (this.data) {
      this.audio = this.data.audio;
      this.audio['keywords'] = "keywords" in this.audio ? this.audio.keywords : [];
      console.log("Got audio data......", this.audio);
    }
    else {
      this.audio = {
        content: '',
        // coverImage: '',
        title: '',
        chapter: '',
        url: '',
        categories: [],
        keywords: []
      }
    }
  }

  async saveAudio(e: any) {
    if (!this.audio.chapter) {
      //  if (!this.audio.chapter) {
      //     this.snackbar.open('Please enter chapter', 'OK', { duration: 3000 });
      //   }
      this.snackbar.open('Please enter chapter', 'OK', { duration: 3000 });
    }
    else if (!this.audio.title) {
      this.snackbar.open('Please upload audio', 'OK', { duration: 3000 });
    }
    else {
      this.showLoader = true;
      e.target.disabled = true;
      let categoryLevelVariable: any;
      let categoriesId = [];

      if (this.categoryOneId == undefined
      ) {
        categoryLevelVariable = ''
      } else if (this.categoryOneId != undefined && this.categoryTwoId == undefined && this.categoryThreeId == undefined
      ) {
        categoriesId.push(this.categoryOneId)
        categoryLevelVariable = 'L1'
      } else if (this.categoryOneId != undefined
        && this.categoryTwoId != undefined
        && this.categoryThreeId == undefined || this.categoryThreeId == ''
      ) {
        categoriesId.push(...[this.categoryOneId, this.categoryTwoId])
        categoryLevelVariable = 'L2'
      } else if (this.categoryOneId != undefined
        && this.categoryTwoId != undefined
        && this.categoryThreeId != undefined
      ) {
        categoriesId.push(...[this.categoryOneId, this.categoryTwoId, this.categoryThreeId])
        categoryLevelVariable = 'L3'
      }
      console.log("save data", this.audio);
      console.log("audioArr", this.audioArr);
      if (!this.audioArr || this.audioArr.length === 0) {
        // console.log(this.audio)
      
          this.audioTitle = this.audio.title
        

        const audioObj = {
          ...this.audio,
          url: this.audio.url,
          title: this.audioTitle,
          categories: categoriesId,
          categoryLevel: {
            [categoriesId[categoriesId.length - 1]]: categoryLevelVariable
          }
        }

        await this.audioService.updateAudios(audioObj, this.audio.id);
        this.snackbar.open('Audio Saved Successfully', 'OK', { duration: 3000 });
      } else {
        console.log('asdfghjkkjhgfdsasd');
        for (let audio of this.audioArr) {
          console.log("audioArr", this.audioArr);

          if (this.audioArr.length > 1) {
            console.log('aaaaaaaaaa')
            this.audioTitle = audio.url.name.replace(/.mp3/g, '');
            console.log('audioTitle', this.audioTitle)
          } else {
            console.log('bbbbbbbbbbbbb')
            this.audioTitle = this.audio.title
          }

          const audioObj = {
            ...this.audio,
            url: audio.url,
            title: this.audioTitle,
            categories: categoriesId,
            categoryLevel: {
              [categoriesId[categoriesId.length - 1]]: categoryLevelVariable
            }
          }
          console.log("audioObj", audioObj);
          await this.audioService.updateAudios(audioObj, this.audio.id);    // this.dialogRef.close({ data: this.audio });
          this.snackbar.open('Audio Saved Successfully', 'OK', { duration: 3000 });
        }
      }


      this.dialogRef.close({
        status: 'success'
      });


      e.target.disabled = false;
      this.showLoader = false;
    }


  }


  async uplaodAudiofile(e: any) {

    if (e.target.files.length > 0) {

      console.log('e.target.files', e.target.files)
      for (let i = 0; i < e.target.files.length; i++) {
        console.log('e.target.files', e.target.files[i])
        this.audioArr.push({ url: e.target.files[i] })
        console.log('audioArr', this.audioArr)

      }
    }


    console.log("this.audio.title : ,", this.audio.title);
  }



  changeCategoryOneName(e: any) {
    this.categoryOneId = e.value
    this.getCategoryTwo(this.categoryOneId)
  }

  changeCategoryTwoName(e: any) {
    this.categoryTwoId = e.value
    this.getCategoryThree(this.categoryOneId, this.categoryTwoId)
  }

  changeCategoryThreeName(e: any) {
    this.categoryThreeId = e.value
  }

  // async sendImageEvent(e: any) {
  //   if (e.target.files.length > 0) {
  //     const imageWithBase64 = await this.utilityService.getBase64FromFile(e.target.files[0]);
  //     this.audio.coverImage = imageWithBase64;
  //   }
  // }

  removeImage() {
    this.audio.coverImage = '';
  }

  async removeAudioFromArray(index: any) {
    // console.log('this.audio', audio.url.name)

    this.audioArr.splice(index, 1)

  }

  async removeAudio() {
    // console.log('this.audio', audio.url.name)
    this.audio.title = '';
    this.audio.url = '';

  }

  addKeyword() {
    const value = (this.keyword || '').trim().toLowerCase();
    console.log("value", value);
    if (value) {
      const index = this.audio.keywords.indexOf(value);
      if (index > -1) {
        this.snackbar.open('Already added', 'OK', { duration: 3000 });
      } else {
        this.audio.keywords.push(value);
      }
    }
    this.keyword = '';
    console.log("keywords", this.audio.keywords);
  }

  removeKeyword(keyword: string) {
    const index = this.audio.keywords.indexOf(keyword);
    if (index > -1) {
      this.audio.keywords.splice(index, 1);
    }
  }

}
