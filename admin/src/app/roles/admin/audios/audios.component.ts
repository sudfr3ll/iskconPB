import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { EditAudioComponent } from '../dialogs/edit-audio/edit-audio.component';
import { AudioService } from 'src/app/services/audio.service';
import { Subscription } from 'rxjs';
import { MatCheckboxChange } from '@angular/material/checkbox';
import { SharedService } from 'src/app/services/shared.service';


@Component({
  selector: 'app-audios',
  templateUrl: './audios.component.html',
  styleUrls: ['./audios.component.scss']
})
export class AudiosComponent implements OnInit {
  audios: any;
  audiosSub: Subscription | undefined;
  showLoader: boolean = true;

  check: boolean = false;
  showHeader: any = false;
  indeterminate = false;
  count: any;

  constructor(
    private audioService: AudioService,
    public dialog: MatDialog,
    private sharedService: SharedService
  ) { }

  async ngOnInit(){
  await this.getAudios()
    this.showLoader = false;
  }

  async getAudios(){
    // this.audios = await this.audioService.getAudios();

    const audios = this.audioService.audios$.getValue();

    if (!audios.length) {
      await this.audioService.getAudios();
    }

    this.audiosSub = this.audioService.audios$.subscribe(audio => {
      this.audios = audio
    })

  }


  async editAudio(audio: any) {
    const audioClone = JSON.parse(JSON.stringify(audio))
    const dialogRef = this.dialog.open(EditAudioComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content',
      data: {
        audio: audioClone,
        // categOneData: this.categOneData
        // category
      }
    })

    dialogRef.afterClosed().subscribe(async result => {
      this.showLoader = true;
      // await this.getAudios()
      
      if (result === 'success') {
        this.audiosSub = this.audioService.audios$.subscribe(audio => {
          this.audios = audio
    })}
      this.showLoader = false;
    });
 
  }

  async addAudio() {
    const dialogRef = this.dialog.open(EditAudioComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content',

    })

    dialogRef.afterClosed().subscribe(async result => {
      // console.log('result.data',result.data)
      // this.audios.push(result.data)

    });
 
  }

  deleteAudio(id: any) {
    this.sharedService.deleteSingleDoc(id, 'Audios')
  }


  ngOnDestroy() {
    this.audiosSub?.unsubscribe();
  }

  onSelectCheckBox(ob: MatCheckboxChange, item: any, data: any) {
    const obj = this.sharedService.onSelectCheckBox(ob, item, data)
    this.showHeader = obj.showHead;
    this.indeterminate = obj.indeterminate
    this.count = obj.count
  }

  onClickSelectAllCheckBox(ob: MatCheckboxChange, data: any) {

    const obj = this.sharedService.onClickSelectAllCheckBox(ob, data)
    this.count = obj.count
    this.showHeader = obj.showHead;
    this.indeterminate = obj.indeterminate
    this.count = obj.count
  }

  onClickCross(data: any) {
    const obj = this.sharedService.onClickCross(data)
    this.showHeader = obj.showHead;
    this.indeterminate = obj.indeterminate
    this.count = obj.count
  }

  openDeleteConfirmationModal(): void {
    this.sharedService.openDeleteConfirmationModal('Audios')
    this.showHeader = false;
    this.indeterminate = false
    // this.count = 0
    for (let item of this.audios) {
      item.checked = false;
    }
  }
  
}
