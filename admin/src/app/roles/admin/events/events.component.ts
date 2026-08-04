import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Subscription } from 'rxjs';
import { EventsService } from 'src/app/services/events.service';
import { EditEventComponent } from '../dialogs/edit-event/edit-event.component';
import { SharedService } from 'src/app/services/shared.service';
import { MatCheckboxChange } from '@angular/material/checkbox';

@Component({
  selector: 'app-events',
  templateUrl: './events.component.html',
  styleUrls: ['./events.component.scss']
})
export class EventsComponent implements OnInit {
  events: any;
  eventsSub: Subscription | undefined;
  showLoader: boolean = true;
  enable!: boolean;
  check: boolean = false;
  showHeader: any = false;
  indeterminate = false;
  checked = true;
  count: any;
  selectedIdsToDeleteArray: any = [];

  constructor(
    private eventsService: EventsService,
    public dialog: MatDialog,
    private sharedService: SharedService
  ) { }

  async ngOnInit() {
    await this.getAllEvents()
    this.showLoader = false;
    console.log(this.events)
  }

  async getAllEvents() {
    const events = this.eventsService.events$.getValue();
    if (!events.length) {
      await this.eventsService.getEvents();
    }

    this.eventsSub = this.eventsService.events$.subscribe(events => {
      this.events = events;
    });
  }

  async editEvent(event: any) {
    const cloneEvent = JSON.parse(JSON.stringify(event))
    const dialogRef = this.dialog.open(EditEventComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content',
      data: {
        event: cloneEvent,
      }
    });

    dialogRef.afterClosed().subscribe(async result => {
      // console.log('result.data',result.data)
      this.showLoader = true;
      await this.getAllEvents()
      this.showLoader = false;
    });
  }

  async addNewEvent() {
    this.dialog.open(EditEventComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content'
    });
  }

  deleteEvent(id: any) {
    this.sharedService.deleteSingleDoc(id, 'Events')
  }

  ngOnDestroy() {
    this.eventsSub?.unsubscribe();
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
    this.sharedService.openDeleteConfirmationModal('Events')
    this.showHeader = false;
    this.indeterminate = false
    // this.count = 0
    for (let item of this.events) {
      item.checked = false;
    }
  }

  getImage(data: any) {
    return this.sharedService.getImage(data)
  }

}
