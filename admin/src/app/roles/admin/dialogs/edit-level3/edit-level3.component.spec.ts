import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditLevel3Component } from './edit-level3.component';

describe('EditLevel3Component', () => {
  let component: EditLevel3Component;
  let fixture: ComponentFixture<EditLevel3Component>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EditLevel3Component ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EditLevel3Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
