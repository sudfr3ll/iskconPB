import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LiveDarshanComponent } from './live-darshan.component';

describe('LiveDarshanComponent', () => {
  let component: LiveDarshanComponent;
  let fixture: ComponentFixture<LiveDarshanComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ LiveDarshanComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(LiveDarshanComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
