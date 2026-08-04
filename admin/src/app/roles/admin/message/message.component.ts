import { Component, HostListener, OnInit } from '@angular/core';
// import { MatDialog } from '@angular/material/dialog';
import { EditMessageComponent } from '../dialogs/edit-message/edit-message.component';
import { MessagesService } from 'src/app/services/messages.service';
import { Subscription } from 'rxjs';
import { ThemePalette } from '@angular/material/core';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { SharedService } from 'src/app/services/shared.service';
import { MatCheckboxChange } from '@angular/material/checkbox';
import { SlowBuffer } from 'buffer';

export interface Task {
  name: string;
  completed: boolean;
  color: ThemePalette;
  subtasks?: Task[];
  selectedIdsToDeleteArray: [];

}

@Component({
  selector: 'app-message',
  templateUrl: './message.component.html',
  styleUrls: ['./message.component.scss'],
})

export class MessageComponent implements OnInit {
  @HostListener("window:scroll", ["$event"])
  messages: any;
  messagesSub: Subscription | undefined;
  showLoader: boolean = true;

  check: boolean = false;
  showHeader: any = false;
  indeterminate = false;
  count: any;


  constructor(
    private messagesService: MessagesService,
    public dialog: MatDialog,
    public sharedService: SharedService
  ) { }

  async ngOnInit() {

    await this.getAllMessages()
    this.showLoader = false;

    this.onWindowScroll()

  }


  async getAllMessages() {
    this.showLoader = true;

    const messasges = this.messagesService.messages$.getValue();

    if (!messasges.length) {
      await this.messagesService.getMessages();
    }

    this.messagesSub = this.messagesService.messages$.subscribe(messages => {
      this.messages = messages
    });

    for (let message of this.messages) {
      message.checked = false;
    }
    this.showLoader = false;


  }

  async editMessage(message: any) {
    const cloneMessage = JSON.parse(JSON.stringify(message))
    const dialogRef = this.dialog.open(EditMessageComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content',
      data: {
        message: cloneMessage,
      }
    });

    dialogRef.afterClosed().subscribe(async result => {
      this.showLoader = true;
      await this.getAllMessages()
      this.showLoader = false;
    });
  }

  addNewMessage() {
    this.dialog.open(EditMessageComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content'
    });
  }

  deleteMessage(id: any) {
    this.sharedService.deleteSingleDoc(id, 'Message')
    // this.count = 0
  }


  ngOnDestroy() {
    this.messagesSub?.unsubscribe();
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
    this.sharedService.openDeleteConfirmationModal('Message')
    this.showHeader = false;
    this.indeterminate = false
    // this.count = 0
    for (let item of this.messages) {
      item.checked = false;
    }
  }

  // onScroll(event: any) {

  //   if (event.target.offsetHeight + event.target.scrollTop >= event.target.scrollHeight) {
  //     console.log("End");
  //   }

  //   console.log(event.target.offsetHeight)
  //   console.log(event.target.scrollTop)
  //   console.log(event.target.scrollHeight)

  // }

  onWindowScroll() {
    //In chrome and some browser scroll is given to body tag
    let pos = (document.documentElement.scrollTop || document.body.scrollTop) + document.documentElement.offsetHeight;
    let max = document.documentElement.scrollHeight;
    // pos/max will give you the distance between scroll bottom and and bottom of screen in percentage.
    if (pos == max) {
      //Do your action here
    }


  }

  getImage(data: any) {
    return this.sharedService.getImage(data)
  }

}